module Mint
  class Formatter
    def format(node : Ast::Operation) : String
      left =
        format node.left

      right =
        format node.right

      if node.new_line? &&
         node.right.is_a?(Ast::Operation)
        "#{left} #{node.operator}\n#{indent(right.remove_all_leading_whitespace)}"
      else
        "#{left} #{node.operator} #{right}"
      end
    end
  end
end
