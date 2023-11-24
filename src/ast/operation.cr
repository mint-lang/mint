module Mint
  class Ast
    class Operation < Node
      getter operator, right, left

      def initialize(@file : Parser::File,
                     @operator : String,
                     @right : Node,
                     @from : Int64,
                     @left : Node,
                     @to : Int64)
      end
    end
  end
end
