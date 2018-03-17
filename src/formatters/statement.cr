class Formatter
  def format(node : Ast::Statement) : String
    expression =
      format node.expression

    name =
      format node.name

    if name
      "#{name} =\n#{expression.indent}"
    else
      expression
    end
  end
end
