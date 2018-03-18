class Formatter
  def format(node : Ast::CssMedia) : String
    body =
      list node.definitions

    "@media #{node.content.strip} {\n#{body.indent}\n}"
  end
end
