module Mint
  class Ast
    class Route < Node
      getter url, expression, arguments, head_comments, tail_comments

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @arguments : Array(Argument),
                     @expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @url : String,
                     @to : Int32)
      end
    end
  end
end
