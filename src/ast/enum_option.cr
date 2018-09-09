module Mint
  class Ast
    class EnumOption < Node
      getter value, comment, parameters

      def initialize(@parameters : Array(Node),
                     @comment : Comment?,
                     @value : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
