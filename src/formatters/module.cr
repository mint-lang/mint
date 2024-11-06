module Mint
  class Formatter
    def format(node : Ast::Module) : Nodes
      items =
        node.constants +
          node.functions +
          node.comments

      comment =
        format_documentation_comment node.comment

      comment + ["module "] + format(node.name) + [" "] +
        group(
          behavior: Behavior::Block,
          items: [list(items)],
          ends: {"{", "}"},
          separator: "",
          pad: false)
    end
  end
end
