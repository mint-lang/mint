module Mint
  class TypeChecker
    def check(node : Ast::HtmlExpression) : Type
      resolve node.expression
    end
  end
end
