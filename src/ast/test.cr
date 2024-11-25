module Mint
  class Ast
    class Test < Node
      getter expression, name, refs

      def initialize(@refs : Array(Tuple(Variable, Node)),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @name : StringLiteral,
                     @file : Parser::File,
                     @expression : Block)
      end
    end
  end
end
