module Mint
  class TypeChecker
    type_error HtmlAttributeComponentPropertyTypeMismatch
    type_error HtmlAttributeElementAttributeTypeMismatch
    type_error HtmlAttributeNotFoundComponentProperty
    type_error HtmlAttributeComponentKeyTypeMismatch
    type_error HtmlAttributeFragmentKeyTypeMismatch
    type_error HtmlElementClassNameForbidden
    type_error HtmlElementRefForbidden

    def check(node : Ast::HtmlAttribute, element : Ast::HtmlFragment)
      got =
        resolve node.value

      raise HtmlAttributeFragmentKeyTypeMismatch, {
        "expected" => STRING,
        "node"     => node,
        "got"      => got,
      } unless Comparer.compare(STRING, got)

      got
    end

    def check(node : Ast::HtmlAttribute, element : Ast::HtmlElement) : Checkable
      got =
        resolve node.value

      expected =
        case node.name.value.downcase
        when "ref"
          raise HtmlElementRefForbidden, {
            "node" => node,
          }
        when .starts_with?("on")
          [EVENT_FUNCTION, VOID_FUNCTION]
        when "readonly", "disabled"
          [BOOL]
        when "className"
          raise HtmlElementClassNameForbidden, {
            "node" => node,
          }
        when "style"
          [STYLE_MAP]
        else
          [STRING]
        end

      raise HtmlAttributeElementAttributeTypeMismatch, {
        "expected" => expected.map(&.to_s).join(", "),
        "tag"      => element.tag.value,
        "name"     => node.name.value,
        "node"     => node,
        "got"      => got,
      } unless expected.any? { |item| Comparer.compare(item, got) }

      got
    end

    def check(node : Ast::HtmlAttribute, component : Ast::Component) : Checkable
      type = resolve node.value

      case node.name.value
      when "key"
        raise HtmlAttributeComponentKeyTypeMismatch, {
          "component" => component.name,
          "expected"  => STRING,
          "got"       => type,
          "node"      => node,
        } unless Comparer.compare(type, STRING)
      else
        prop =
          component
            .properties
            .find(&.name.value.==(node.name.value))

        raise HtmlAttributeNotFoundComponentProperty, {
          "properties" => component.properties.map(&.name.value),
          "name"       => node.name.value,
          "component"  => component.name,
          "node"       => node,
        } unless prop

        prop_type =
          scope component do
            resolve prop
          end

        raise HtmlAttributeComponentPropertyTypeMismatch, {
          "name"      => prop.name.value,
          "component" => component.name,
          "expected"  => prop_type,
          "node"      => node,
          "got"       => type,
        } unless Comparer.compare(prop_type, type)
      end

      type
    end
  end
end
