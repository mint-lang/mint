module Mint
  class Ast
    class ForCondition < Node
      getter condition, head_comments, tail_comments

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @condition : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
