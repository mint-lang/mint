module Mint
  class TypeChecker
    def check(node : Ast::CommentedExpression) : Checkable
      resolve node.expression
    end
  end
end
