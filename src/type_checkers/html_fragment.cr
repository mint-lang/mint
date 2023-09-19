module Mint
  class TypeChecker
    def check(node : Ast::HtmlFragment) : Checkable
      check_html node.children

      HTML
    end
  end
end
