module Mint
  class Ast
    class Function < Node
      getter name, where, arguments, body, type
      getter comment, head_comments, tail_comments

      property keep_name : Bool = false

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @arguments : Array(Argument),
                     @type : TypeOrVariable?,
                     @comment : Comment?,
                     @body : Expression,
                     @name : Variable,
                     @where : Where?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
