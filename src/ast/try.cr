module Mint
  class Ast
    class Try < Node
      getter statements, catches, comments, catch_all

      def initialize(@statements : Array(Statement),
                     @comments : Array(Comment),
                     @catches : Array(Catch),
                     @catch_all : CatchAll?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
