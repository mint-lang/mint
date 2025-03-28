module Mint
  class Ast
    class CaseBranch < Node
      getter patterns, expression

      def initialize(@expression : Node | Array(CssDefinition),
                     @from : Parser::Location,
                     @patterns : Array(Node)?,
                     @to : Parser::Location,
                     @file : Parser::File)
      end
    end
  end
end
