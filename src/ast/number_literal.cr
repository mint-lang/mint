module Mint
  class Ast
    class NumberLiteral < Node
      getter? float
      getter value

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @value : String,
                     @float : Bool)
      end
    end
  end
end
