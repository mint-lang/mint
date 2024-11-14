module Mint
  class Ast
    class TupleDestructuring < Node
      getter items

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @items : Array(Node))
      end
    end
  end
end
