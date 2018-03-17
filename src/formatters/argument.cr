class Formatter
  def format(node : Ast::Argument) : String
    name =
      format node.name

    type =
      format node.type

    "#{name} : #{type}"
  end
end
