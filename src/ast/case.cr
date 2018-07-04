module Mint
  class Ast
    class Case < Node
      getter branches, condition, comments

      def initialize(@branches : Array(CaseBranch),
                     @comments : Array(Comment),
                     @condition : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
