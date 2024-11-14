module Mint
  class Ast
    class Field < Node
      getter key, value, comment

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @key : Variable?,
                     @value : Node)
      end
    end
  end
end
