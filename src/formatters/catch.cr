class Formatter
  def format(node : Ast::Catch) : String
    body =
      format node.expression

    variable =
      format node.variable

    type =
      format node.type

    "catch #{type} => #{variable} {\n#{body.indent}\n}"
  end
end
