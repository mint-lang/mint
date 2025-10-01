module Mint
  class TypeChecker
    def check(node : Ast::HtmlComponent) : Checkable
      component =
        node.component_node

      error! :html_component_not_found_component do
        snippet "I was looking for a component but could not find one with " \
                "the name:", node.component.value

        snippet "It's used here:", node
      end unless component

      error! :html_component_global_component do
        snippet "Global components are added to the body and always rendered " \
                "and cannot be used as regular components:", node
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

        error! :html_component_attribute_required do
          snippet "One of the required properties were not specified for " \
                  "a component:", property
          snippet "The component was referenced here:", node
        end unless attributes.includes?(property.name.value)
      end

      node.ref.try do |ref|
        error! :html_component_reference_outside_of_component do
          snippet "Referencing components outside of components is not " \
                  "allowed:", ref
        end unless node.ancestor
      end

      component.contexts.each do |context|
        resolve context

        case type = lookups[context][0]
        when Ast::TypeDefinition
          error! :context_no_context do
            block "If a type is used in a context it must have a default value."
            snippet "The type is defined here:", type
            snippet "The context in question is here:", context
          end unless type.context
        end
      end

      check_html node.children

      lookups[node] = {component, nil}

      HTML
    end
  end
end
