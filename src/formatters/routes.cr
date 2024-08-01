module Mint
  class Formatter
    def format(node : Ast::Routes) : Nodes
      ["routes "] + group(
        items: [list(node.routes + node.comments)],
        behavior: Behavior::Block,
        ends: {"{", "}"},
        separator: "",
        pad: false)
    end
  end
end
