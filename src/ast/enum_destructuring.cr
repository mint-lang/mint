module Mint
  class Ast
    class EnumDestructuring < Node
      alias EnumDestructuringParameter = DestructuringType | TypeVariable

      getter name, option, parameters

      def initialize(@parameters : Array(EnumDestructuringParameter),
                     @option : String,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
