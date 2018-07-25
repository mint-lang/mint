module Mint
  class Ast
    class InlineFunction < Node
      getter body, arguments, head_comments, tail_comments, type

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @arguments : Array(Argument),
                     @body : Expression,
                     @input : Data,
                     @from : Int32,
                     @type : Type,
                     @to : Int32)
      end
    end
  end
end
