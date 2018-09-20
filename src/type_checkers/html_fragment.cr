module Mint
  class TypeChecker
    def check(node : Ast::HtmlFragment) : Checkable
      check_html node.children

      node.key.try { |key| resolve key, node }

      HTML
    end
  end
end
