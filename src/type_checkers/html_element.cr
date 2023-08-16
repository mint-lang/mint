module Mint
  class TypeChecker
    def static_type_signature(node : Ast::HtmlElement) : Checkable
      Type.new("Dom.Element")
    end

    def check(node : Ast::HtmlElement) : Checkable
      unless node.styles.empty?
        error :html_element_style_outside_of_component do
          block "Referencing elements are not allowed outside of components."

          snippet node
        end unless component?

        resolve node.styles
      end

      node.ref.try do |ref|
        error :html_element_reference_outside_of_component do
          block "Styling of elements are not allowed outside of components."

          snippet ref
        end unless component?
      end

      node.attributes.each { |attribute| resolve attribute, node }

      check_html node.children

      HTML
    end
  end
end
