module Mint
  class TypeChecker
    def check(node : Ast::HtmlExpression) : Checkable
      check_html node.expressions

      HTML
    end
  end
end
