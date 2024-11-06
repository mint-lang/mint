module Mint
  class Formatter
    def format(node : Ast::HtmlFragment) : Nodes
      group(
        items: [list(node.children + node.comments)],
        behavior: Behavior::BreakAll,
        ends: {"<>", "</>"},
        separator: "",
        pad: false)
    end
  end
end
