module Mint
  class TypeChecker
    def check(node : Ast::ParenthesizedExpression) : Type
      resolve node.expression
    end
  end
end
