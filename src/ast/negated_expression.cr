module Mint
  class Ast
    class NegatedExpression < Node
      getter expression, negations

      def initialize(@expression : Expression,
                     @negations : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
