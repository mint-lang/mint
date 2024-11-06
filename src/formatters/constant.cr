module Mint
  class Formatter
    def format(node : Ast::Constant) : Nodes
      comment =
        format_documentation_comment node.comment

      expression =
        format node.expression

      name =
        format node.name

      comment + break_not_fits(
        items: {["const "] + name, expression},
        separator: " =")
    end
  end
end
