module Mint
  class TypeChecker
    def check(node : Ast::Directives::Size) : Checkable
      case item = lookup(node.ref)
      when Ast::HtmlElement
        lookups[node] = {item, nil}

        resolve dom_get_dimensions
        resolve dom_dimensions_empty

        check! ast.unified_modules.find!(&.name.value.==("Dom"))
        check! ast.unified_modules.find!(&.name.value.==("Dom.Dimensions"))

        type =
          resolve ast.type_definitions.find!(&.name.value.==("Dom.Dimensions"))

        Type.new("Maybe", [type])
      else
        error! :size_directive_expected_html_element do
          block "A size directive must reference an HTML element but it doesn't."
          snippet "The size directive in question is here:", node
        end
      end
    end
  end
end
