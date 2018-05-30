module Mint
  class TypeChecker
    def check(node : Ast::NegatedExpression) : Type
      BOOL
    end
  end
end
