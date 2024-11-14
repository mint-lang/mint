module Mint
  class Ast
    class Test < Node
      getter expression, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @name : StringLiteral,
                     @file : Parser::File,
                     @expression : Block)
      end
    end
  end
end
