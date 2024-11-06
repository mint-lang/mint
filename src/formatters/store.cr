module Mint
  class Formatter
    def format(node : Ast::Store) : Nodes
      items =
        node.functions +
          node.constants +
          node.comments +
          node.signals +
          node.states +
          node.gets

      comment =
        format_documentation_comment node.comment

      name =
        format node.name

      body =
        list items

      comment + ["store "] + name + [" "] + group(
        behavior: Behavior::Block,
        ends: {"{", "}"},
        separator: "",
        items: [body],
        pad: false)
    end
  end
end
