module Mint
  class TypeChecker
    type_error HtmlElementReferenceOutsideOfComponent
    type_error HtmlElementStyleOutsideOfComponent

    def check(node : Ast::HtmlElement) : Checkable
      unless node.styles.empty?
        raise HtmlElementStyleOutsideOfComponent, {
          "node" => node,
        } unless component?

        resolve node.styles
      end

      node.ref.try do |ref|
        raise HtmlElementReferenceOutsideOfComponent, {
          "node" => ref,
        } unless component?
      end

      node.attributes.each { |attribute| resolve attribute, node }

      check_html node.children

      HTML
    end
  end
end
