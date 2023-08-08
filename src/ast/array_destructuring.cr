module Mint
  class Ast
    class ArrayDestructuring < Node
      getter items

      def initialize(@file : Parser::File,
                     @items : Array(Node),
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
