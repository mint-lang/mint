module Mint
  class Compiler
    def _compile(node : Ast::HtmlExpression) : Codegen::Node
      case node.expressions.size
      when 0
        "null"
      when 1
        compile node.expressions.first
      else
        children =
          compile node.expressions

        Codegen.join ["_h(React.Fragment, {}, ", js.array(children), ")"]
      end
    end
  end
end
