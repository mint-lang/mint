class Formatter
  def format(node : Ast::Routes) : String
    body =
      format node.routes, "\n\n"

    "routes {\n#{body.indent}\n}"
  end
end
