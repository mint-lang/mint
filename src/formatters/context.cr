module Mint
  class Formatter
    def format(node : Ast::Context) : Nodes
      comment =
        format_documentation_comment node.comment

      name =
        format node.name

      type =
        format(node.type) do |item|
          [" : "] + format(item)
        end

      comment + ["context "] + name + type
    end
  end
end
