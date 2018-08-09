module Mint
  class Ast
    class CaseBranch < Node
      getter match, expression

      def initialize(@match : EnumDestructuring | Expression | Nil,
                     @expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
