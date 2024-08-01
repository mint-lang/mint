module Mint
  class Formatter
    def format(node : Ast::Operation) : Nodes
      left =
        format node.left

      right =
        format node.right

      if node.right.is_a?(Ast::Operation)
        left + [" #{node.operator} "] + right
      else
        left + [" #{node.operator} "] + right
      end
    end
  end
end
