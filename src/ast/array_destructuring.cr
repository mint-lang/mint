module Mint
  class Ast
    class ArrayDestructuring < Node
      getter items

      def initialize(@items : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
