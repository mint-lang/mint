module Mint
  class Ast
    class Js < Node
      getter value, type

      def initialize(@value : Array(String | Interpolation),
                     @input : Data,
                     @from : Int32,
                     @type : Node?,
                     @to : Int32)
      end
    end
  end
end
