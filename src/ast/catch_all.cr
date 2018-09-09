module Mint
  class Ast
    class CatchAll < Node
      getter expression, head_comments, tail_comments

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
