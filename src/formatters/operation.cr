class Formatter
  def format(node : Ast::Operation) : String
    left =
      format node.left

    right =
      format node.right

    "#{left} #{node.operator} #{right}"
  end
end
