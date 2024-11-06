module Mint
  class Formatter
    def format(node : Ast::Component) : Nodes
      items =
        node.properties +
          node.constants +
          node.functions +
          node.comments +
          node.connects +
          node.styles +
          node.states +
          node.gets +
          node.uses

      global =
        node.global? ? format("global") : [] of Node

      async =
        node.async? ? format("async") : [] of Node

      comment =
        format_documentation_comment node.comment

      name =
        format node.name

      body =
        group(
          behavior: Behavior::Block,
          items: [list(items)],
          ends: {"{", "}"},
          separator: "",
          pad: false)

      rest =
        [async, global, ["component"], name, body]
          .reject(&.empty?)
          .intersperse(format(" "))
          .flatten

      comment + rest
    end
  end
end
