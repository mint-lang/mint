module Mint
  class Ast
    class Get < Node
      getter name, body, type, comment

      def initialize(@type : TypeOrVariable?,
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
