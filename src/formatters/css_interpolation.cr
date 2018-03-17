class Formatter
  def format(node : Ast::CssInterpolation) : String
    body =
      format node.expression

    "{#{body}}"
  end
end
