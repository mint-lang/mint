module Mint
  class Formatter
    def format(node : Ast::TypeDefinitionField) : Nodes
      comment =
        format_documentation_comment node.comment

      type =
        format node.type

      key =
        format node.key

      mapping =
        format(node.mapping) do |item|
          [" using "] + format(item)
        end

      comment + break_not_fits(
        items: {key, type + mapping},
        separator: " :")
    end
  end
end
