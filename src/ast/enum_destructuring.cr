module Mint
  class Ast
    class EnumDestructuring < Node
      getter name, option, parameters

      def initialize(@parameters : Array(Node),
                     @option : String,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
