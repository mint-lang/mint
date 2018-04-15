class Formatter
  def format(node : Ast::Test) : String
    expression =
      format node.expression

    name =
      format node.name

    "test #{name} {\n#{expression.indent}\n}"
  end
end
