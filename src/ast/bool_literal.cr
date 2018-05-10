module Mint
  class Ast
    class BoolLiteral < Node
      getter value

      def initialize(@value : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
