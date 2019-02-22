module Mint
  class Ast
    class For < Node
      getter head_comments, tail_comments, subject, body, items, condition

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @condition : ForCondition | Nil,
                     @items : Array(Argument),
                     @subject : Expression,
                     @body : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
