module Mint
  class Ast
    class BoolLiteral < Node
      getter value

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @value : Bool)
      end
    end
  end
end
