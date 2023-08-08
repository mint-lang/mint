module Mint
  class Ast
    class CaseBranch < Node
      getter pattern, expression

      def initialize(@expression : Node | Array(CssDefinition),
                     @file : Parser::File,
                     @pattern : Node?,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
