class Formatter
  def format(node : Ast::Get) : String
    name =
      format node.name

    type =
      format node.type

    body =
      format node.body

    "get #{name} : #{type} {\n#{body.indent}\n}"
  end
end
