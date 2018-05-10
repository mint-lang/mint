module Mint
  class Ast
    class Type < Node
      getter name, parameters

      def initialize(@parameters : Array(TypeOrVariable),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
