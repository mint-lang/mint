module Mint
  class Ast
    class CaseBranch < Node
      getter pattern, expression

      def initialize(@expression : Node | Array(CssDefinition),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @pattern : Node?)
      end
    end
  end
end
