module Mint
  class TypeChecker
    type_error HtmlComponentReferenceOutsideOfComponent
    type_error HtmlComponentAttributeRequired
    type_error HtmlComponentNotFoundComponent
    type_error HtmlComponentGlobalComponent

    def check(node : Ast::HtmlComponent) : Checkable
      component =
        ast.components.find(&.name.==(node.component.value))

      raise HtmlComponentNotFoundComponent, {
        "name" => node.component.value,
        "node" => node,
      } unless component

      raise HtmlComponentGlobalComponent, {
        "name" => node.component.value,
        "node" => node,
      } if component.global

      resolve component

      attributes =
        node
          .attributes
          .map do |attribute|
            resolve attribute, component
            attribute.name.value
          end

      component.properties.each do |property|
        next if property.default

        raise HtmlComponentAttributeRequired, {
          "property" => property,
          "node"     => node,
        } unless attributes.includes?(property.name.value)
      end

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
