module Mint
  class Compiler
    def _compile(node : Ast::HtmlFragment) : String
      attributes =
        if key = node.key
          "{ #{compile key} }"
        else
          "{}"
        end

      children =
        if node.children.empty?
          "[]"
        else
          items =
            compile node.children, ", "

          "[#{items}]"
        end

      "_createElement(React.Fragment, #{attributes}, #{children})"
    end
  end
end
