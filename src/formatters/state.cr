module Mint
  class Formatter
    def format(node : Ast::State) : Nodes
      comment =
        format_documentation_comment node.comment

      default =
        format node.default

      name =
        format node.name

      type =
        format(node.type) do |item|
          [" : "] + format(item)
        end

      head =
        ["state "] + name + type

      comment + break_not_fits(
        items: {head, default},
        separator: " =")
    end
  end
end
