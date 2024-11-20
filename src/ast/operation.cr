module Mint
  class Ast
    class Operation < Node
      getter operator, comment, right, left

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @operator : String,
                     @right : Node,
                     @left : Node)
      end
    end
  end
end
