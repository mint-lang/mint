module Mint
  class Ast
    class Try < Node
      getter statements, catches, comments

      def initialize(@statements : Array(Statement),
                     @comments : Array(Comment),
                     @catches : Array(Catch),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
