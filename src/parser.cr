module Mint
  class Parser
    getter input : Array(Char)
    getter file : String
    getter ast = Ast.new
    getter data : Ast::Data
    getter refs = [] of {Ast::Variable, Ast::HtmlComponent | Ast::HtmlElement}
    getter position = 0

    def initialize(input : String, @file)
      @input = input.chars
      @data = Ast::Data.new(input, @file)
    end

    def <<(node)
      ast.nodes << node
      node
    end

    # Helpers for manipulating position
    # ----------------------------------------------------------------------------

    def start(&)
      start_position = position

      begin
        node = yield position
        @position = start_position unless node
        clear_nodes(start_position) unless node
        node
      rescue error : Error
        @position = start_position
        clear_nodes(start_position)
        raise error
      end
    end

    def clear_nodes(from_position)
      ast.nodes.reject! { |node| node.from >= from_position }
    end

    def step
      @position += 1
    end

    def eof? : Bool
      @position == input.size
    end

    # Helpers for raising errors
    # ----------------------------------------------------------------------------

    def raise(error : SyntaxError.class, position : Int32, raw : Hash(String, T)) forall T
      whitespace_index = next_whitespace_index
      to = whitespace_index ? whitespace_index - position : 0

      node =
        Ast::Node.new(
          to: position + to,
          from: position,
          input: data)

      part =
        substring(position, to)

      raise error, {
        "node" => node,
        "got"  => part,
      }.merge(raw)
    end

    def raise(error : SyntaxError.class, position : Int32)
      raise error, position, {} of String => String
    end

    def raise(error : SyntaxError.class)
      raise error, position, {} of String => String
    end

    # Inspect current character, look ahead and look behind
    # ----------------------------------------------------------------------------

    def char : Char
      input[position]? || '\0'
    end

    def next_char : Char
      input[position + 1]? || '\0'
    end

    def prev_char : Char
      input[position - 1]? || '\0'
    end

    # Consuming characters
    # ----------------------------------------------------------------------------

    def letters_or_numbers
      chars { |char| char.ascii_letter? || char.ascii_number? }
    end

    def letters_numbers_or_dash
      chars { |char| char.ascii_letter? || char.ascii_number? || char == '-' }
    end

    def letters_numbers_or_underscore
      chars { |char| char.ascii_letter? || char.ascii_number? || char == '_' }
    end

    def char!(next_char : Char)
      return false unless char == next_char
      step
      true
    end

    def char(next_char : Char, error : SyntaxError.class) : Int32?
      raise error unless char == next_char
      step
    end

    def char(& : Char -> Bool)
      return unless yield char
      step
    end

    def char(error : SyntaxError.class, & : Char -> Bool)
      raise error unless yield char
      step
    end

    def chars(& : Char -> Bool)
      while char != '\0' && (yield char)
        step
      end
    end

    def chars(next_char : Char)
      chars { |char| char == next_char }
    end

    def chars(*next_chars : Char)
      chars &.in?(next_chars)
    end

    def chars_until(& : Char -> Bool)
      while char != '\0' && !(yield char)
        step
      end
    end

    def chars_until(next_char : Char)
      chars_until { |char| char == next_char }
    end

    def chars_until(*next_chars : Char)
      chars_until &.in?(next_chars)
    end

    # Gathering many consumes
    # ----------------------------------------------------------------------------

    def gather(&) : String?
      start_position = position

      yield

      if position > start_position
        result = substring(start_position, position - start_position)
        result unless result.empty?
      end
    end

    # Consuming keywords
    # ----------------------------------------------------------------------------

    def keyword!(word, error, save : Bool = false) : Bool
      keyword(word, save) || raise error
    end

    def keyword_ahead?(word) : Bool
      word.each_char_with_index do |char, i|
        return false unless input[position + i]? == char
      end
      true
    end

    def keyword(word, save : Bool = false) : Bool
      if keyword_ahead?(word)
        if save
          @ast.keywords << {position, position + word.size}
        end

        @position += word.size
        true
      else
        false
      end
    end

    # Consuming whitespaces
    # ----------------------------------------------------------------------------

    def whitespace!(error : SyntaxError.class) : String?
      raise error unless whitespace?
      whitespace
    end

    def whitespace?
      char.ascii_whitespace?
    end

    def whitespace : String?
      consume_while whitespace?
    end

    def track_back_whitespace : Nil
      while prev_char.ascii_whitespace?
        @position -= 1
      end
    end

    # Consuming variables
    # ----------------------------------------------------------------------------

    def type_or_type_variable
      type || type_variable
    end

    def type_or_type_variable!(error : SyntaxError.class)
      type_or_type_variable || raise error
    end

    # Consuming many things
    # ----------------------------------------------------------------------------

    def many(parse_whitespace : Bool = true, & : -> T?) : Array(T) forall T
      result = [] of T

      loop do
        # Consume whitespace
        whitespace if parse_whitespace

        # Break if the block didn't yield anything
        break unless item = yield

        # Add item to results
        result << item
      end

      result
    end

    def list(terminator : Char?, separator : Char, & : -> T?) : Array(T) forall T
      result = [] of T

      loop do
        # Break if we reached the end
        break if char == terminator

        # Break if the block didn't yield anything
        break unless item = yield

        # Add item to results
        result << item

        # Consume whitespace before the separator
        whitespace

        # Break if there is no separator, consume it otherwise
        break unless char! separator

        # Consume whitespace
        whitespace
      end

      result
    end

    # Gets substring out of the original string
    def substring(from, to)
      @data.input[from, to]
    end

    private def next_whitespace_index
      current_position = position
      while current_position < input.size
        if input[current_position].whitespace?
          return current_position
        end
        current_position &+= 1
      end
      nil
    end
  end
end
