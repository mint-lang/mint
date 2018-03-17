class Formatter
  def format(node : Ast::Property) : String
    default =
      format node.default

    name =
      format node.name

    type =
      format node.type

    "property #{name} : #{type} = #{default}"
  end
end
