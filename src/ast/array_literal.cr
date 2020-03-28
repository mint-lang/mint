module Mint
  class Ast
    class ArrayLiteral < Node
      getter items, type

      def initialize(@items : Array(Expression),
                     @input : Data,
                     @from : Int32,
                     @type : Node?,
                     @to : Int32)
      end

      def static?
        items.all?(&.static?)
      end

      def static_value
        values =
          items.join(',', &.static_value)

        "[#{values}]"
      end
    end
  end
end
