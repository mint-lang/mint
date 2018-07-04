module Mint
  class Ast
    class Catch < Node
      getter variable, expression, type, head_comments, tail_comments

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @expression : Expression,
                     @variable : Variable,
                     @type : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
