module Mint
  class Ast
    class ArrayDestructuring < Node
      getter items

      def initialize(@items : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def spread?
        items.any?(Ast::Spread)
      end
    end
  end
end
