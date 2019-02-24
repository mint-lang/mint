module Mint
  class Parser
    getter input, position, file, ast, data, refs

    def initialize(@input : String, @file : String)
      @refs = [] of {Ast::Variable, Ast::HtmlComponent | Ast::HtmlElement}
      @data = Ast::Data.new(@input, @file)
      @ast = Ast.new
      @position = 0
    end

    # Helpers for manipulating position
    # ----------------------------------------------------------------------------

    def start
      start_position = position
      begin
        yield position
      rescue SkipError
        @position = start_position
        nil
      rescue error : Error
        @position = start_position
        raise error
      end
    end

    def skip
      raise SkipError.new
    end

    def step
      @position += 1
    end

    def eof? : Bool
      @position == input.size
    end

    # Helpers for raising errors
    # ----------------------------------------------------------------------------

    def raise(error : SyntaxError.class, position : Int32)
      to =
        input[position, input.size]
          .split(/\s|\n|\r/)
          .first
          .size

      node =
        Ast::Node.new(
          to: position + to,
          from: position,
          input: data)

      part =
        input[position, to]

      raise error, {
        "node" => node,
        "got"  => part,
      }
    end

    def raise(error : SyntaxError.class)
      raise error, position
    end

    def raise(error : SkipError.class)
      raise error.new
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

    def char!(next_char : Char)
      if char == next_char
        step
        true
      else
        false
      end
    end

    def char(set : String, error : SyntaxError.class | SkipError.class) : Int32 | Nil
      if !char.in_set?(set)
        raise error
      else
        step
      end
    end

    def char(next_char : Char, error : SyntaxError.class | SkipError.class) : Int32 | Nil
      if char != next_char
        raise error
      else
        step
      end
    end

    def chars(set) : String | Nil
      consume_while char != '\0' && char.in_set? set
    end

    # Gathering many consumes
    # ----------------------------------------------------------------------------

    def gather : String | Nil
      start_position = position
      yield
      if position > start_position
        input[start_position, position - start_position]
      end
    end

    # Consuming keywords
    # ----------------------------------------------------------------------------

    def keyword!(word, error) : Bool | Nil
      raise error unless keyword(word)
    end

    def keyword_ahead(word) : Bool
      result = input[position, word.size]

      result == word
    end

    def keyword(word) : Bool
      result = input[position, word.size]
      if result == word
        @position += word.size
        true
      else
        false
      end
    end

    # Consuming whitespaces
    # ----------------------------------------------------------------------------

    def whitespace!(error : SyntaxError.class | SkipError.class) : String | Nil
      if char.in_set? "^ \n\t\r"
        raise error
      else
        whitespace
      end
    end

    def whitespace?
      char.in_set? " \n\t\r"
    end

    def whitespace : String | Nil
      consume_while whitespace?
    end

    def track_back_whitespace : Nil
      while prev_char.in_set? " \n\t\r"
        @position -= 1
      end
    end

    # Consuming variables
    # ----------------------------------------------------------------------------

    def type_or_type_variable
      type || type_variable
    end

    def type_or_type_variable!(error : SyntaxError.class)
      raise error unless result = type_or_type_variable
      result
    end

    # Consuming many things
    # ----------------------------------------------------------------------------

    def many(parse_whitespace : Bool = true, &block : -> T) : Array(T) forall T
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

    def list(terminator : Char, separator : Char, &block : -> T) : Array(T) forall T
      result = [] of T

      loop do
        # Break if we reached the end
        break if char == terminator

        # Break if the block didn't yield anything
        break unless item = yield

        # Add item to results
        result << item

        # Break if there is no separator, consume it otherwise
        break unless char! separator

        # Consume whitespace
        whitespace
      end

      result
    end
  end
end
