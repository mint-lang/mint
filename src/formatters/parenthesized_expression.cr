class Formatter
  def format(node : Ast::ParenthesizedExpression) : String
    "(#{format node.expression})"
  end
end
