module Mint
  class Ast
    class RegexpLiteral < Node
      getter value, flags

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @value : String,
                     @flags : String)
      end
    end
  end
end
