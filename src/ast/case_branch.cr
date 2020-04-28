module Mint
  class Ast
    class CaseBranch < Node
      getter match, expression

      def initialize(@expression : Node | Array(CssDefinition),
                     @match : Node?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
