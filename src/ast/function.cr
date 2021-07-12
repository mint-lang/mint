module Mint
  class Ast
    class Block < Node
      getter statements

      def initialize(@statements : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end

    class Function < Node
      getter name, where, arguments, body, type
      getter comment, head_comments, tail_comments

      property? keep_name = false

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
