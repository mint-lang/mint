module Mint
  class Compiler2
    def compile(node : Ast::HtmlFragment) : Compiled
      if node.children.empty?
        ["null"] of Item
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
