module Mint
  class TypeChecker
    def check(node : Ast::ParenthesizedExpression) : Type
      check node.expression
    end
  end
end
