module Mint
  class Ast
    class Operation < Node
      getter operator, await, right, left

      def initialize(@file : Parser::File,
                     @operator : String,
                     @await : Bool?,
                     @right : Node,
                     @from : Int64,
                     @left : Node,
                     @to : Int64)
      end
    end
  end
end
