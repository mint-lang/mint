module Mint
  class Compiler
    def _compile(node : Ast::HtmlExpression) : String
      case node.expressions.size
      when 0
        "null"
      when 1
        compile node.expressions.first
      else
        children =
          compile node.expressions

        "_h(React.Fragment, {}, #{js.array(children)})"
      end
    end
  end
end
