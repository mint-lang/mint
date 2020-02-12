module Mint
  class Ast
    class Variable < Node
      getter value

      def initialize(@constant : Bool,
                     @value : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
