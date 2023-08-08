module Mint
  class Ast
    class Operation < Node
      getter left, right, operator

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
