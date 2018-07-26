module Mint
  class Compiler
    def compile(node : Ast::HtmlFragment) : String
      children =
        if node.children.empty?
          "[]"
        else
          items =
            compile node.children, ", "

          "[#{items}]"
        end

      "_createElement(React.Fragment, {}, #{children})"
    end
  end
end
