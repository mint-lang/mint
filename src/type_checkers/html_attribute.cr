module Mint
  class TypeChecker
    def check(node : Ast::HtmlAttribute, element : Ast::HtmlFragment)
      got =
        resolve node.value

      error :html_attribute_fragment_key_type_mismatch do
        block do
          text "The"
          bold "key"
          text "attribute of a fragment has an invalid type. It can only be:"
          code "String"
        end

        expected STRING, got

        snippet node
      end unless Comparer.compare(STRING, got)

      got
    end

    def check(node : Ast::HtmlAttribute, element : Ast::HtmlElement) : Checkable
      got =
        resolve node.value

      expected =
        case node.name.value.downcase
        when "ref"
          error :html_element_ref_forbidden do
            block "The use of ref attribute is forbidden."
            block "If you want to save a reference to an element, use the as keyword."
            snippet node
          end
        when .starts_with?("on")
          [EVENT_FUNCTION, VOID_FUNCTION]
        when "readonly", "disabled", "checked"
          [BOOL]
        when "className"
          error :html_element_class_name_forbidden do
            block "The className attribute on elements are forbidden."

            block do
              text "Please use"
              bold "class"
              text "instead."
            end

            snippet node
          end
        when "style"
          [STYLE_MAP, STRING]
        else
          [STRING]
        end

      error :html_attribute_element_attribute_type_mismatch do
        block do
          text "The type of the value for the property"
          bold node.name.value
          text "of element"
          bold element.tag.value
          text "does not match its type."
        end

        snippet "I was expecting one of the following types:", expected.join(", ")
        snippet "Instead it is:", got

        snippet node
      end unless expected.any? { |item| Comparer.compare(item, got) }

      got
    end

    def check(node : Ast::HtmlAttribute, component : Ast::Component) : Checkable
      type = resolve node.value

      case node.name.value
      when "key"
        error :html_attribute_component_key_type_mismatch do
          block do
            text "The"
            bold "key"
            text "attribute of a component has an invalid type. It can only be:"
            code "String"
          end

          expected STRING, type

          snippet node
        end unless Comparer.compare(type, STRING)
      else
        prop =
          component
            .properties
            .find(&.name.value.==(node.name.value))

        error :html_attribute_not_found_component_property do
          block do
            text "I was looking for the property"
            bold node.name.value
            text "on the"
            bold component.name.value
            text "component but could not find it."
          end

          snippet "Maybe you want one of its properties:",
            component.properties.map(&.name.value).join("\n")

          snippet node
        end unless prop

        lookups[node] = prop

        prop_type =
          scope component do
            resolve prop
          end

        error :html_attribute_component_property_type_mismatch do
          block do
            text "The type of the value for the property"
            bold prop.name.value
            text "of the component"
            bold component.name.value
            text "does not match its definition."
          end

          expected prop_type, type

          snippet node
        end unless Comparer.compare(prop_type, type)
      end

      type
    end
  end
end
