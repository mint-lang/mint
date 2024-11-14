module Mint
  class Ast
    class ArrayLiteral < Node
      getter items, type

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @items : Array(Node),
                     @type : Node?)
      end
    end
  end
end
