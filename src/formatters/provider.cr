module Mint
  class Formatter
    def format(node : Ast::Provider) : Nodes
      items =
        node.functions +
          node.constants +
          node.comments +
          node.signals +
          node.states +
          node.gets

      comment =
        format_documentation_comment node.comment

      subscription =
        format node.subscription

      name =
        format node.name

      comment + ["provider "] + name + [" : "] + subscription + [" "] +
        group(
          behavior: Behavior::Block,
          items: [list(items)],
          ends: {"{", "}"},
          separator: "",
          pad: false)
    end
  end
end
