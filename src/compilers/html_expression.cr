module Mint
  class Compiler
    def _compile(node : Ast::HtmlExpression) : String
      if node.expressions.empty?
        "null"
      elsif node.expressions.size == 1
        compile node.expressions[0]
      else
        children =
          compile node.expressions

        "_h(React.Fragment, {}, #{js.array(children)})"
      end
    end
  end
end
