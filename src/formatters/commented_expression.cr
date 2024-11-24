module Mint
  class Formatter
    def format(node : Ast::CommentedExpression) : Nodes
      comment =
        format_documentation_comment node.comment

      expression =
        format node.expression

      comment + expression
    end
  end
end
