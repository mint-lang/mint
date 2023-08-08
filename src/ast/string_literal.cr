module Mint
  class Ast
    class StringLiteral < Node
      getter? broken
      getter value

      def initialize(@value : Array(String | Interpolation),
                     @file : Parser::File,
                     @broken : Bool,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
