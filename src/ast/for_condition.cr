module Mint
  class Ast
    class ForCondition < Node
      getter condition

      def initialize(@condition : Block,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
