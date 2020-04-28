module Mint
  class Ast
    class NumberLiteral < Node
      getter value
      getter? float

      def initialize(@value : BigDecimal,
                     @input : Data,
                     @float : Bool,
                     @from : Int32,
                     @to : Int32)
      end

      def static?
        true
      end

      def static_value
        (float? ? value : value.to_i64).to_s
      end
    end
  end
end
