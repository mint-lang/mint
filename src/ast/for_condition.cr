module Mint
  class Ast
    class ForCondition < Node
      getter condition

      def initialize(@condition : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
