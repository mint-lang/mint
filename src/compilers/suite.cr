class Compiler
  def compile(node : Ast::Test)
    name =
      compile node.name

    expression =
      compile node.expression
    "{ name: #{name}, proc: () => { return #{expression} } }"
  end
end
