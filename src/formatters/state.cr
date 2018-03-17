class Formatter
  def format(node : Ast::State) : String
    type =
      format node.type

    data =
      format node.data

    "state : #{type} #{data}"
  end
end
