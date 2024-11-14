module Mint
  class Ast
    class Operation < Node
      getter operator, right, left

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @operator : String,
                     @right : Node,
                     @left : Node)
      end
    end
  end
end
