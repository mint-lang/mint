module Mint
  class TypeChecker
    type_error HtmlElementReferenceOutsideOfComponent
    type_error HtmlElementStyleOutsideOfComponent
    type_error HtmlElementNotFoundStyle

    def check(node : Ast::HtmlElement) : Checkable
      styles =
        node.styles

      if styles
        raise HtmlElementStyleOutsideOfComponent, {
          "node" => styles.map(&.value).join("::"),
        } unless component?

        style_nodes =
          styles.map do |style|
            style_node =
              component.styles.find(&.name.value.==(style.value))

            raise HtmlElementNotFoundStyle, {
              "style" => style.value,
              "node"  => style,
            } unless style_node

            resolve style_node

            style_node
          end

        style_lookups[node] = style_nodes
        html_elements[node] = component
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
