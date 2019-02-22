module Mint
  class Ast
    class StringLiteral < Node
      getter value, broken

      def initialize(@value : String,
                     @broken : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
