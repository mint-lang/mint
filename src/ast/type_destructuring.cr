module Mint
  class Ast
    class TypeDestructuring < Node
      getter variant, items, name

      def initialize(@items : Array(Node),
                     @file : Parser::File,
                     @from : Int64,
                     @variant : Id,
                     @to : Int64,
                     @name : Id?)
      end
    end
  end
end
