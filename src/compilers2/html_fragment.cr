module Mint
  class Compiler2
    def compile(node : Ast::HtmlFragment) : Compiled
      compile node do
        case node.children.size
        when 0
          js.null
        when 1
          compile node.children.first
        else
          items =
            compile node.children

          js.call(Builtin::CreateElement, [
            [Builtin::Fragment] of Item,
            ["{}"] of Item,
            js.array(items),
          ])
        end
      end
    end
  end
end
