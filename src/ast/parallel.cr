module Mint
  class Ast
    class Parallel < Node
      getter statements, catches, then_branch, finally, comments, catch_all

      def initialize(@statements : Array(Statement),
                     @comments : Array(Comment),
                     @then_branch : Then?,
                     @finally : Finally?,
                     @catches : Array(Catch),
                     @catch_all : CatchAll?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
