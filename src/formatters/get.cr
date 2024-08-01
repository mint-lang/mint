module Mint
  class Formatter
    def format(node : Ast::Get) : Nodes
      comment =
        format_documentation_comment node.comment

      name =
        format node.name

      body =
        format node.body

      type =
        format(node.type) do |item|
          [" : "] + format(item)
        end

      comment + ["get "] + name + type + [" "] + body
    end
  end
end
