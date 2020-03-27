module Mint
  class Ast
    class ArrayDestructuring < Node
      getter items

      def initialize(@items : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      # Returns true if the destructuring covers
      # arrays with the given length.
      #
      # [x, ...rest] => 1+
      # [x]          => 1
      # [...rest]    => 0+
      # []           => 0
      def covers?(length)
        if spread?
          length >= (items.size - 1)
        else
          length == items.size
        end
      end

      def spread?
        items.any?(Ast::Spread)
      end
    end
  end
end
