module Mint
  class Ast
    class For < Node
      getter head_comments, tail_comments, subject, body, arguments, condition

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @condition : ForCondition | Nil,
                     @arguments : Array(Variable),
                     @subject : Expression,
                     @body : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
