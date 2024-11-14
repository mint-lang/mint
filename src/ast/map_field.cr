module Mint
  class Ast
    class MapField < Node
      getter key, value, comment

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @value : Node,
                     @key : Node)
      end
    end
  end
end
