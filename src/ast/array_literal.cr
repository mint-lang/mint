module Mint
  class Ast
    class ArrayLiteral < Node
      getter items

      def initialize(@items : Array(Expression),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def static?
        items.all?(static?)
      end

      def static_value
        values =
          items.map(&.static_value).join(",")

        "[#{values}]"
      end
    end
  end
end
