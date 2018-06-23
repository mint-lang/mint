module Mint
  class Ast
    class CaseBranch < Node
      getter match, expression, comment

      def initialize(@match : Expression | Nil,
                     @expression : Expression,
                     @comment : Comment?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
