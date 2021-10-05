module Mint
  class Ast
    class Get < Node
      getter name, body, type, comment, head_comments, tail_comments

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @type : TypeOrVariable?,
                     @comment : Comment?,
                     @body : Expression,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
