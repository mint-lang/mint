module Mint
  class Parser
    include Errorable
    include Helpers

    # The position of the cursor, which is at the character we are currently
    # parsing.
    getter position : Int64 = 0

    # The input which is an array of characters because this way it's faster in
    # cases where the original code contains multi-byte characters.
    getter input : Array(Char)

    # The abstract syntax tree.
    getter ast = Ast.new

    # The parsed file, we save it so we can show parse errors.
    getter file : File

    def initialize(input : String, path : String)
      @file = File.new(input, path)
      @input = input.chars
    end

    # Parses a thing (an ast node). Yielding the start position so the thing
    # getting parsed can use it. If the block returns nil or we rollback to
    # the start position since it means the parsing has failed.
    #   track - if true we save the resulting node
    def parse(*, track : Bool = true, &)
      operators_size = ast.operators.size
      keywords_size = ast.keywords.size
      nodes_size = ast.nodes.size
      start_position = position

      (yield position, nodes_size, @errors.size).tap do |node|
        case node
        when Ast::Node
          ast.nodes << node if track
        when Nil
          ast.operators.delete_at(operators_size...)
          ast.keywords.delete_at(keywords_size...)
          ast.nodes.delete_at(nodes_size...)
          @position = start_position
        end
      end
    end

    # Moves the cursor forward by one character.
    def step
      @position += 1
    end

    # Returns whether or not the cursor is at the end of the file.
    def eof? : Bool
      @position == input.size
    end

    # Checks if we reached the end of the file raises an error otherwise.
    def eof! : Bool
      whitespace
      error :expected_eof { expected "the end of the file", word } unless eof?
      true
    end

    # Returns the current character.
    def char : Char
      input[position]? || '\0'
    end

    # If the character is parsed with the given block, moves the cursor forward.
    def char(& : Char -> Bool)
      step if yield char
    end

    # If the character is the current character, moves the cursor forward.
    def char!(expected : Char)
      char { |current| current == expected }
    end

    # Returns the next character.
    def next_char : Char
      input[position + 1]? || '\0'
    end

    # Returns the previous character.
    def previous_char : Char
      input[position - 1]? || '\0'
    end

    # Returns the current word (sequence of ascii lowercase letters).
    def ascii_word : String
      index = position
      word = ""

      while (input[index]? || '\0').ascii_letter?
        word += input[index]
        index += 1
      end

      word
    end

    # Parses any number of ascii latters or numbers.
    def ascii_letters_or_numbers(*, extra_char : Char? = nil)
      chars { |char| char.ascii_letter? || char.ascii_number? || char == extra_char }
    end

    # Parses any number of ascii uppercase latters, numbers or underscore and
    # must start with an uppercase letter.
    def ascii_uppercase_and_underscore
      chars { |char| char.ascii_uppercase? || char.ascii_number? || char == '_' }
    end

    # Consumes characters while the yielded value is true or we reach the end
    # of the file.
    def chars(& : Char -> Bool)
      while char != '\0' && (yield char)
        step
      end
    end

    # Consumes characters while the yielded value is in one of the given
    # characters.
    def chars(*next_chars : Char)
      chars &.in?(next_chars)
    end

    # Starts to parse something, if the cursor moved during, return the parsed
    # string.
    def gather(&) : String?
      start_position = position

      yield

      if position > start_position
        result = file.contents[start_position, position - start_position]
        result unless result.empty?
      end
    end

    # Consumes characters until the yielded value is true.
    def consume(& : -> Bool) : Nil
      while yield
        step
      end
    end

    # Returns the word (non whitespace sequence) a the cursor.
    def word : String?
      start_position = position
      word = ""

      while !(eof? || whitespace?)
        word += char
        step
      end

      @position = start_position
      word
    end

    # Returns whether or not the word is at the current position.
    def word?(word) : Bool
      word.chars.each_with_index.all? do |char, i|
        input[position + i]? == char
      end
    end

    # Consumes a word and steps the cursor forward if successful.
    def word!(expected : String) : Bool
      if word?(expected)
        @position += expected.size

        if expected.chars.all?(&.ascii_lowercase?) &&
           !expected.blank? &&
           expected != "or"
          @ast.keywords << {position - expected.size, position}
        end

        true
      else
        false
      end
    end

    # Consumes all available whitespace.
    def whitespace : Nil
      chars &.ascii_whitespace?
    end

    # Returns whether the current character is a whitespace.
    def whitespace? : Bool
      char.ascii_whitespace?
    end

    # Consumes all available whitespace and returns true / false whether
    # there were any.
    def whitespace! : Bool
      parse do |start_position|
        whitespace
        next false if position == start_position
        true
      end
    end

    # Parses a variable identifier.
    def identifier_variable : String?
      return unless char.ascii_lowercase?
      gather { ascii_letters_or_numbers }
    end

    # Parses a constant identifier.
    def identifier_constant : String?
      return unless char.ascii_uppercase?
      gather { ascii_uppercase_and_underscore }
    end

    # Parses a type identifier.
    def identifier_type : String?
      parse do
        name = gather do
          next unless char.ascii_uppercase?
          ascii_letters_or_numbers
        end

        next if char == '_'
        next unless name

        parse do
          next unless char! '.'
          next unless other = identifier_type

          name += ".#{other}"
        end

        name
      end
    end

    # Parse many things separated by whitespace.
    def many(parse_whitespace : Bool = true, & : -> T?) : Array(T) forall T
      result = [] of T

      loop do
        # Using parse here will not consume the whitespace if
        # the parsing is not successfull.
        item = parse(track: false) do
          # Consume whitespace
          whitespace if parse_whitespace
          yield
        end

        # Break if the block didn't yield anything
        break unless item

        # Add item to results
        result << item
      end

      result
    end

    # Parses a list of things, which ends in the terminator character and are
    # separated by the separator character.
    def list(terminator : Char?, separator : Char, & : -> T?) : Array(T) forall T
      result = [] of T

      loop do
        item = parse(track: false) do
          # Consume whitespace before the next thing
          whitespace

          # Return nil if we reached the end
          next if char == terminator
          yield
        end

        # Break if the block didn't yield anything
        break unless item

        # Add item to results
        result << item

        # Using parse here will not consume whitespace if there is no separator.
        parsed_separator = parse do
          # Consume whitespace before the separator
          whitespace

          # Break if there is no separator, consume it otherwise
          next unless char! separator

          # This is needed to actually finish the consuming.
          true
        end

        break unless parsed_separator
      end

      result
    end

    # Parses a block surrounded by brackets.
    def brackets(opening_bracket_error : Proc(Nil)? = nil,
                 closing_bracket_error : Proc(Nil)? = nil,
                 empty_check : Proc(T, Nil)? = nil,
                 & : -> T?) : T? forall T
      parse(track: false) do
        unless char! '{'
          case item = opening_bracket_error
          when Proc(Nil)
            next item.call
          else
            next
          end
        end

        whitespace
        result = yield.tap { |value| empty_check.try(&.call(value)) }
        whitespace

        unless char! '}'
          case item = closing_bracket_error
          when Proc(Nil)
            next item.call
          else
            next
          end
        end

        result
      end
    end

    # Parses a thing, if succeeds it discards all errors while parsing it.
    def oneof(& : -> T?) : T? forall T
      # Copy the errors for later use.
      errors = self.errors.dup

      # Empty the errors, since we want to gather them.
      @errors = [] of Error

      yield.tap do |result|
        if result
          # Restore the original errors
          @errors = errors
        else
          # Restore the original errors and add the new ones.
          @errors = errors + @errors
        end
      end
    end

    # Parses a raw part of the input until we reach the terminator or an
    # interpolation (if it's needed).
    def raw(terminator : Char, stop_on_interpolation : Bool = true) : String?
      gather do
        while char != '\0'
          break if previous_char != '\\' &&
                   char == terminator

          break if stop_on_interpolation &&
                   previous_char != '\\' &&
                   next_char == '{' &&
                   char == '#'

          step
        end
      end
    end

    # Parses a raw part of the input until we reach the terminator or an
    # interpolation.
    def raw(token : String) : String?
      raw { !word?(token) }
    end

    # Parses a raw part of the input until we reach the terminator or an
    # interpolation.
    def raw(& : -> Bool) : String?
      gather do
        while char != '\0' && yield
          break if previous_char != '\\' &&
                   next_char == '{' &&
                   char == '#'

          step
        end
      end
    end
  end
end
