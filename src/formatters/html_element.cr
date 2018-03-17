class Formatter
  def format(node : Ast::HtmlElement) : String
    tag =
      format node.tag

    style =
      format node.style

    prefix =
      if style
        "#{tag}::#{style}"
      else
        tag
      end

    format(prefix: prefix, tag: tag, node: node)
  end
end
