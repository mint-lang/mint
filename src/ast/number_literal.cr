module Mint
  class Ast
    class NumberLiteral < Node
      getter? float
      getter value

      def initialize(@file : Parser::File,
                     @value : String,
                     @float : Bool,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
