module Mint
  class TypeChecker
    def check(node : Ast::HtmlExpression) : Type
      check node.expression
    end
  end
end
