class Compiler
  def compile(node : Ast::ArrayLiteral) : String
    items =
      compile node.items, ", "

    "[#{items}]"
  end
end
