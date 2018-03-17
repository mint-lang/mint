class Compiler
  def compile(node : Ast::InlineFunction) : String
    body =
      compile node.body

    arguments =
      compile node.arguments, ", "

    "((#{arguments}) => {\nreturn #{body}\n})"
  end
end
