module Mint
  class TypeChecker
    def check(node : Ast::HtmlStyle) : Checkable
      style =
        node.style_node

      error! :html_style_not_found do
        snippet "I was looking for a style but it's not defined in the " \
                "component:", node
      end unless style

      type =
        resolve style

      check_call(node, type)

      lookups[node] = {style, nil}

      VOID
    end
  end
end
