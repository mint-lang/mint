module Mint
  class Ast
    class EnumOption < Node
      getter value, comment, parameters

      def initialize(@parameters : Array(TypeVariable | Type),
                     @comment : Comment?,
                     @value : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
