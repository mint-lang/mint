module Mint
  class Formatter
    def format(node : Ast::CssKeyframes) : Nodes
      ["@keyframes #{node.name} "] + group(
        items: [list(node.selectors)],
        behavior: Behavior::Block,
        ends: {"{", "}"},
        separator: "",
        pad: false)
    end
  end
end
