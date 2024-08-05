module Mint
  class Formatter
    def format(node : Ast::Case) : Nodes
      items =
        node.branches + node.comments

      condition =
        format node.condition

      body =
        list items

      ["case "] + condition + [" "] +
        group(
          behavior: Behavior::Block,
          ends: {"{", "}"},
          separator: "",
          items: [body],
          pad: false)
    end
  end
end
