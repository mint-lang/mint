module Mint
  class Formatter
    def format(node : Ast::Function) : Nodes
      comment =
        format_documentation_comment node.comment

      name =
        format node.name

      body =
        format node.body

      type =
        format node.type do |item|
          [": "] + format(item)
        end

      head =
        entity(
          arguments: node.arguments.map(&->format(Ast::Node)),
          head: [format("fun "), name].flatten,
          tail: type)

      comment + head + [" "] + body
    end
  end
end
