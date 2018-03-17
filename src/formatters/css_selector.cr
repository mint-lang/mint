class Formatter
  def format(node : Ast::CssSelector) : String
    selectors =
      node
        .selectors
        .map { |item| "&#{item}" }
        .join(",\n")

    body =
      list node.definitions

    "#{selectors} {\n#{body.indent}\n}"
  end
end
