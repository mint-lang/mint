module Mint
  class TypeChecker
    type_error HtmlElementStyleOutsideOfComponent
    type_error HtmlElementNotFoundStyle

    def check(node : Ast::HtmlElement) : Type
      style =
        node.style

      if style
        raise HtmlElementStyleOutsideOfComponent, {
          "node" => style,
        } unless component?

        style_node =
          component.styles.find(&.name.value.==(style.value))

        raise HtmlElementNotFoundStyle, {
          "style" => style.value,
          "node"  => style,
        } unless style_node

        html_elements[node] = component
      end

      node.attributes.each { |attribute| check attribute, node }

      check_html node.children

      HTML
    end
  end
end
