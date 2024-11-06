module Mint
  class Formatter
    def format(node : Ast::Style) : Nodes
      name =
        format node.name

      body =
        group(
          behavior: Behavior::Block,
          items: [list(node.body)],
          ends: {"{", "}"},
          separator: "",
          pad: false)

      entity(
        arguments: node.arguments.map(&->format(Ast::Node)),
        head: [format("style "), name].flatten,
        tail: format("")) + body
    end
  end
end
