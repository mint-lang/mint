module Mint
  class Ast
    class CaseBranch < Node
      getter match, expression

      def initialize(@expression : Expression,
                     @match : Node | Nil,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
