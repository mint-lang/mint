module Mint
  class Ast
    class TupleDestructuring < Node
      getter items

      def initialize(@items : Array(Node),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
