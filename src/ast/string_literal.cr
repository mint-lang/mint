module Mint
  class Ast
    class StringLiteral < Node
      getter? broken
      getter value

      def initialize(@value : Array(String | Interpolation),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @broken : Bool)
      end
    end
  end
end
