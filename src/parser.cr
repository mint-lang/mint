module Mint
  class Parser
    getter input : Array(Char)
    getter file : String
    getter ast = Ast.new
    getter data : Ast::Data
    getter refs = [] of {Ast::Variable, Ast::HtmlComponent | Ast::HtmlElement}
    getter position = 0

    def initialize(input, @file)
      @input = input.chars
      @data = Ast::Data.new(input, @file)
    end

    def <<(node)
      ast.nodes << node
      node
    end

    # Helpers for manipulating position
    # ----------------------------------------------------------------------------

    def start
      start_position = position

      begin
        node = yield position
        @position = start_position unless node
        node
      rescue error : Error
        @position = start_position
        raise error
      end
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
      to =
        input[position, input.size]
          .join
          .split(/\s|\n|\r/)
          .first
          .size

      node =
        Ast::Node.new(
          to: position + to,
          from: position,
          input: data)

      part =
        input[position, to].join

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

    def char!(next_char : Char)
      return false unless char == next_char
      step
      true
    end

    def char(next_char : Char, error : SyntaxError.class) : Int32?
      raise error unless char == next_char
      step
    end

    def char(set : String, error : SyntaxError.class) : Int32?
      raise error unless char.in_set?(set)
      step
    end

    def char(set : String) : Int32?
      return unless char.in_set?(set)
      step
    end

    def chars(set) : String?
      consume_while char != '\0' && char.in_set?(set)
    end

    # Gathering many consumes
    # ----------------------------------------------------------------------------

    def gather : String?
      start_position = position

      yield

      if position > start_position
        result = input[start_position, position - start_position]
        result.join unless result.empty?
      end
    end

    # Consuming keywords
    # ----------------------------------------------------------------------------

    def keyword!(word, error) : Bool
      keyword(word) || raise error
    end

    def keyword_ahead(word) : Bool
      result = input[position, word.size].join
      result == word
    end

    def keyword(word) : Bool
      result = input[position, word.size].join

      if result == word
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

    def many(parse_whitespace : Bool = true, &block : -> T?) : Array(T) forall T
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

    def list(terminator : Char?, separator : Char, &block : -> T?) : Array(T) forall T
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
  end
end
