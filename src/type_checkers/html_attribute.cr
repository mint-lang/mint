module Mint
  class TypeChecker
    def check(node : Ast::HtmlAttribute, element : Ast::HtmlFragment) : Checkable
      got =
        resolve node.value

      error! :html_attribute_fragment_key_type_mismatch do
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
          error! :html_element_ref_forbidden do
            snippet %(The use of "ref" attribute is forbidden:), node
            snippet %(Please use the "as" keyword instead:), "<div as myDiv></div>"
          end
        when .starts_with?("on")
          [EVENT_FUNCTION, VOID_FUNCTION]
        when "readonly", "disabled", "checked"
          [BOOL]
        when "className"
          error! :html_element_class_name_forbidden do
            snippet %(The "className" attribute on elements are forbidden:), node
            snippet %(Please use "class" instead:), %(<div class="container"></div>)
          end
        when "style"
          [STYLE_MAP, STRING]
        else
          [STRING]
        end

      error! :html_attribute_element_attribute_type_mismatch do
        block do
          text "The type of the value for the property"
          bold %("#{node.name.value}")
          text "of element"
          bold %("#{element.tag.value}")
          text "does not match its type."
        end

        if expected.size > 1
          snippet "I was expecting one of the following types:", expected.join(", ")
          snippet "Instead it is:", got
        else
          expected expected.first, got
        end

        snippet "The attribute in question is here:", node
      end unless expected.any? { |item| Comparer.compare(item, got) }

      got
    end

    def check(node : Ast::HtmlAttribute, component : Ast::Component) : Checkable
      type = resolve node.value

      case node.name.value
      when "key"
        error! :html_attribute_component_key_type_mismatch do
          block do
            text "The"
            bold %("key")
            text "attribute of a component has an invalid type."
          end

          expected STRING, type
          snippet "The attribute in question is here:", node
        end unless Comparer.compare(type, STRING)
      else
        prop =
          component
            .properties
            .find(&.name.value.==(node.name.value))

        error! :html_attribute_not_found_component_property do
          block do
            text "I was looking for a property in component"
            bold %("#{component.name.value}")
            text "but could not find it:"
          end

          snippet node.name.value

          snippet "Maybe you want one of its properties:",
            component.properties.map(&.name.value).join("\n")

          snippet "The attribute in question is here:", node
        end unless prop

        lookups[node] = {prop, component}

        prop_type =
          resolve prop

        error! :html_attribute_component_property_type_mismatch do
          block do
            text "The type of the value for the property"
            bold %("#{prop.name.value}")
            text "of the component"
            bold %("#{component.name.value}")
            text "does not match its definition."
          end

          expected prop_type, type

          snippet "The attribute in question is here:", node
        end unless Comparer.compare(prop_type, type)
      end

      type
    end
  end
end
