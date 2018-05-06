module Mint
  class Ast
    class Do < Node
      getter statements, catches, finally

      def initialize(@statements : Array(Statement),
                     @finally : Finally | Nil,
                     @catches : Array(Catch),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
