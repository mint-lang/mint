module Mint
  class Formatter
    def format(node : Ast::Tags) : Nodes
      [Group.new(
        items: node.options.map(&->format(Ast::Node)),
        behavior: Behavior::BreakNotFits,
        separator: " |",
        ends: {"", ""},
        pad: false)] of Node
    end
  end
end
