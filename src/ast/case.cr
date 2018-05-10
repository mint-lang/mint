module Mint
  class Ast
    class Case < Node
      getter branches, condition

      def initialize(@branches : Array(CaseBranch),
                     @condition : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
