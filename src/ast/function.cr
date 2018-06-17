module Mint
  class Ast
    class Function < Node
      getter name, wheres, arguments, body, type, comment

      def initialize(@arguments : Array(Argument),
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
