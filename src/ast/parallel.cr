module Mint
  class Ast
    class Parallel < Node
      getter statements, catches, then_branch, finally, comments

      def initialize(@statements : Array(Statement),
                     @comments : Array(Comment),
                     @then_branch : Then | Nil,
                     @finally : Finally | Nil,
                     @catches : Array(Catch),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
