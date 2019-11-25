module Mint
  class Ast
    class StringLiteral < Node
      getter value, broken

      def initialize(@value : Array(String | Interpolation),
                     @broken : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def string_value
        value
          .select(String)
          .join("")
      end

      def static?
        value.all?(String)
      end

      def static_value
        string_value
      end
    end
  end
end
