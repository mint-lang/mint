module Mint
  class Compiler2
    def compile(node : Ast::HtmlExpression) : Compiled
      case node.expressions.size
      when 0
        ["null"] of Item
      when 1
        compile node.expressions.first
      else
        children =
          compile node.expressions

        js.call(Builtin::CreateElement, [
          [Builtin::Fragment] of Item,
          ["{}"] of Item,
          js.array(children),
        ])
      end
    end
  end
end
