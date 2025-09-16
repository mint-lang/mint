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

        error! :context_not_provided_for do
          block "A value is not provided for this context in an parent component."
          snippet "The context in question is here:", context
          snippet "The component was used here:", node
        end unless (@stack.select(Ast::Component) - [component])
                     .find(&.uses.find(&.provider.value.==(context.type.value)))
      end

      check_html node.children

      lookups[node] = {component, nil}

      HTML
    end
  end
end
