module Mint
  class Formatter
    def format(node : Ast::CssFontFace) : Nodes
      ["@font-face "] + group(
        items: [list(node.definitions)],
        behavior: Behavior::Block,
        ends: {"{", "}"},
        separator: "",
        pad: false)
    end
  end
end
