module Mint
  class Ast
    class Field < Node
      getter key, comment
      property value

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @key : Variable?,
                     @value : Node)
      end

      def discard?
        value.is_a?(Discard)
      end
    end
  end
end
