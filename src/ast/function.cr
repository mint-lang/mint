module Mint
  class Ast
    class Function < Node
      getter name, arguments, body, type
      getter comment

      property? keep_name = false

      def initialize(@arguments : Array(Argument),
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
