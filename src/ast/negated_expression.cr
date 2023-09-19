module Mint
  class Ast
    class NegatedExpression < Node
      getter expression, negations

      def initialize(@file : Parser::File,
                     @negations : String,
                     @expression : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
