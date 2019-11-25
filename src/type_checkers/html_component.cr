module Mint
  class TypeChecker
    type_error HtmlComponentReferenceOutsideOfComponent
    type_error HtmlComponentNotFoundComponent
    type_error HtmlComponentGlobalComponent

    def check(node : Ast::HtmlComponent) : Checkable
      component =
        ast.components.find(&.name.==(node.component))

      raise HtmlComponentNotFoundComponent, {
        "name" => node.component,
        "node" => node,
      } unless component

      raise HtmlComponentGlobalComponent, {
        "name" => node.component,
        "node" => node,
      } if component.global

      resolve component

      node.attributes.each { |attribute| resolve attribute, component }

      node.ref.try do |ref|
        raise HtmlComponentReferenceOutsideOfComponent, {
          "node" => ref,
        } unless component?
      end

      check_html node.children

      lookups[node] = component

      HTML
    end
  end
end
