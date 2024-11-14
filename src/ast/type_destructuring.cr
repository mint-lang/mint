module Mint
  class Ast
    class TypeDestructuring < Node
      getter variant, items, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @items : Array(Node),
                     @variant : Id,
                     @name : Id?)
      end
    end
  end
end
