module Mint
  class TypeChecker
    def check(node : Ast::ParenthesizedExpression) : Checkable
      resolve node.expression
    end
  end
end
