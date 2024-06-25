module Mint
  class Formatter2
    def format(node : Ast::Function) : Nodes
      name =
        format node.name

      type =
        format node.type do |item|
          [": "] + format(item)
        end

      body =
        format node.body

      arguments =
        format_arguments node.arguments

      comment =
        documentation_comment node.comment

      head =
        [["fun"], name, arguments, type]
          .reject(&.empty?)
          .intersperse([" "] of Node)
          .flatten

      comment + head + [" "] + body
    end
  end
end
