module Mint
  class Ast
    class NegatedExpression < Node
      getter expression, negations

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @negations : String,
                     @expression : Node)
      end
    end
  end
end
