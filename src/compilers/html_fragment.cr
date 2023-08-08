module Mint
  class Compiler
    def _compile(node : Ast::HtmlFragment) : String
      if node.children.empty?
        "null"
      else
        items =
          compile node.children

        "_h(React.Fragment, {}, #{js.array(items)})"
      end
    end
  end
end
