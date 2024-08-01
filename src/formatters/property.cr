module Mint
  class Formatter
    def format(node : Ast::Property) : Nodes
      comment =
        format_documentation_comment node.comment

      name =
        format node.name

      type =
        format(node.type) do |item|
          [" : "] + format(item)
        end

      head =
        ["property "] + name + type

      comment +
        if default = node.default
          break_not_fits(
            items: {head, format(default)},
            separator: " =")
        else
          head
        end
    end
  end
end
