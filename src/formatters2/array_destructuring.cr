module Mint
  class Formatter2
    def format(node : Ast::ArrayDestructuring)
      group(
        behavior: Behavior::BreakNotFits,
        items: node.items,
        ends: {"[", "]"},
        separator: ",")
    end
  end
end
