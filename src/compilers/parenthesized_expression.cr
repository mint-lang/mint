class Compiler
  def compile(node : Ast::ParenthesizedExpression) : String
    expression =
      compile node.expression

    "(#{expression})"
  end
end
