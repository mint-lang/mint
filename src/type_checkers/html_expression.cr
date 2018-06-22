module Mint
  class TypeChecker
    def check(node : Ast::HtmlExpression) : Checkable
      resolve node.expression
    end
  end
end
