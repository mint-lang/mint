module Mint
  class Formatter
    def format(node : Ast::Operation) : Nodes
      comment =
        format_documentation_comment(node.comment).tap do |item|
          item.unshift(" ") if item.size > 0
        end

      left =
        format node.left

      right =
        format node.right

      left + comment + [" #{node.operator} "] + right
    end
  end
end
