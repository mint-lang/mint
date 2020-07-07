module Mint
  class TypeChecker
    def check(node : Ast::HtmlExpression) : Checkable
      check_html [node.expression]

      HTML
    end
  end
end
