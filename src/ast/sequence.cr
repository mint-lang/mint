module Mint
  class Ast
    class Sequence < Node
      getter statements, catches, finally, comments

      def initialize(@statements : Array(Statement),
                     @comments : Array(Comment),
                     @finally : Finally | Nil,
                     @catches : Array(Catch),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
