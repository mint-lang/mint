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
          .select(&.is_a?(String))
          .map(&.as(String))
          .join("")
      end
    end
  end
end
