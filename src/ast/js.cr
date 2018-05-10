module Mint
  class Ast
    class Js < Node
      getter value

      def initialize(@value : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
