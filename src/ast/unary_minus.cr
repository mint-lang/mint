module Mint
  class Ast
    class UnaryMinus < Node
      getter expression, negations

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node)
      end
    end
  end
end
