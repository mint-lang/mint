module Mint
  class Ast
    class Where < Node
      getter statements, comments

      def initialize(@statements : Array(WhereStatement),
                     @comments : Array(Comment),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
