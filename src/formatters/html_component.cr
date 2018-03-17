class Formatter
  def format(node : Ast::HtmlComponent) : String
    component =
      format node.component

    format(prefix: component, tag: component, node: node)
  end
end
