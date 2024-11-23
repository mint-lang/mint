module Mint
  class Formatter
    def format(node : Ast::TupleLiteral) : Nodes
      group(
        items: node.items.map(&->format(Ast::Node)),
        comment: format(node.comment),
        behavior: Behavior::BreakAll,
        ends: {"{", "}"},
        separator: ",",
        pad: false)
    end
  end
end
