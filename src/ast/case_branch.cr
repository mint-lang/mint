module Mint
  class Ast
    class CaseBranch < Node
      getter match, expression

      def initialize(@match : Expression | Type | Nil,
                     @expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
