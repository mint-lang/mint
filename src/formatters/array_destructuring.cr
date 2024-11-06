module Mint
  class Formatter
    def format(node : Ast::ArrayDestructuring) : Nodes
      if node.items.empty?
        format("[]")
      else
        group(
          items: node.items.map(&->format(Ast::Node)),
          behavior: Behavior::BreakAll,
          ends: {"[", "]"},
          separator: ",",
          pad: false)
      end
    end
  end
end
