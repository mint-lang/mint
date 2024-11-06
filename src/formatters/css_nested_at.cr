module Mint
  class Formatter
    def format(node : Ast::CssNestedAt) : Nodes
      ["@#{node.name} #{node.content.strip} "] + group(
        behavior: Behavior::Block,
        items: [list(node.body)],
        ends: {"{", "}"},
        separator: "",
        pad: false)
    end
  end
end
