module Mint
  class Formatter
    def format(node : Ast::MapField) : Nodes
      comment =
        format_documentation_comment node.comment

      value =
        format node.value

      key =
        format node.key

      comment + break_not_fits(
        items: {key, value},
        separator: " =>")
    end
  end
end
