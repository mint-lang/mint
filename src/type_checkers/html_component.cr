module Mint
  class TypeChecker
    def check(node : Ast::HtmlComponent) : Checkable
      component =
        ast.components.find(&.name.value.==(node.component.value))

      error :html_component_not_found_component do
        block do
          text "I was looking for a component named"
          bold node.component.value
          text "but I could not find it."
        end

        snippet node
      end unless component

      error :html_component_global_component do
        block do
          text "The component named"
          bold node.component.value
          text "is global and cannot be used."
        end

        block "Global components are added to the body and always rendered."

        snippet node
      end if component.global?

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

        error :html_component_attribute_required do
          block "One of the required properties were not specified for a component."

          snippet "The property in question is:", property
          snippet "The component was referenced here:", node
        end unless attributes.includes?(property.name.value)
      end

      node.ref.try do |ref|
        error :html_component_reference_outside_of_component do
          block "Referencing components are not allowed outside of components."
          snippet ref
        end unless component?
      end

      check_html node.children

      lookups[node] = component

      HTML
    end
  end
end
