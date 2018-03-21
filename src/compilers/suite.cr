class Compiler
  def compile(node : Ast::Suite)
    name =
      compile node.name

    tests =
      compile node.tests, ","

    "{ name: #{name}, tests: [#{tests}] }"
  end

  def compile(node : Ast::Test)
    name =
      compile node.name

    expression =
      compile node.expression
    "{ name: #{name}, proc: () => { return #{expression} } }"
  end
end
