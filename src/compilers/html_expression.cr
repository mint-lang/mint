class Compiler
  def compile(node : Ast::HtmlExpression) : String
    compile node.expression
  end
end
