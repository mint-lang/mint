module Mint
  class Formatter
    def format(node : Ast::TupleDestructuring) : Nodes
      group(
        items: node.items.map(&->format(Ast::Node)),
        behavior: Behavior::BreakAll,
        ends: {"{", "}"},
        separator: ",",
        pad: false)
    end
  end
end
