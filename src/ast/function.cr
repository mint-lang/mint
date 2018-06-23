module Mint
  class Ast
    class Function < Node
      getter name, wheres, arguments, body, type
      getter comment, head_comment, tail_comment

      def initialize(@arguments : Array(Argument),
                     @head_comment : Comment?,
                     @tail_comment : Comment?,
                     @type : TypeOrVariable,
                     @wheres : Array(Where),
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
