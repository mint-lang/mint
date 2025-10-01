module Mint
  class TypeChecker
    def check(node : Ast::HtmlElement) : Checkable
      unless node.styles.empty?
        error! :html_element_style_outside_of_component do
          snippet "Styling of elements outside of components is not " \
                  "allowed:", node
        end unless node.ancestor.is_a?(Ast::Component)

        resolve node.styles
      end

      node.ref.try do |ref|
        error! :html_element_reference_outside_of_component do
          snippet "Referencing elements outside of components or tests " \
                  "is not allowed:", ref
        end unless node.ancestor
      end

      node.attributes.each { |attribute| resolve attribute, node }
      check_html node.children

      HTML
    end
  end
end
