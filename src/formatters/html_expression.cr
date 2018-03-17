class Formatter
  def format(node : Ast::HtmlExpression) : String
    expression =
      format node.expression

    if expression.includes?("\n")
      "<{\n#{expression.indent}\n}>"
    else
      "<{ #{expression} }>"
    end
  end
end
