module Mint
  class Ast
    class NumberLiteral < Node
      getter value, float

      def initialize(@value : Float64,
                     @input : Data,
                     @float : Bool,
                     @from : Int32,
                     @to : Int32)
      end

      def static?
        true
      end

      def static_value
        if float
          value
        else
          value.to_i64
        end.to_s
      end
    end
  end
end
