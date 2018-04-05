class Compiler
  def compile(node : Ast::HtmlComponent) : String
    children =
      if node.children.empty?
        ""
      else
        items =
          compile node.children, ", "

        "[#{items}]"
      end

    attributes =
      compile node.attributes, ", "

    contents =
      ["$#{underscorize(node.component)}",
       "{ #{attributes} }",
       children]
        .reject(&.empty?)
        .join(", ")

    "createElement(#{contents})"
  end
end
