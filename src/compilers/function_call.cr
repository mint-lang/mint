class Compiler
  def compile(node : Ast::FunctionCall) : String
    variable =
      compile node.function

    arguments =
      compile node.arguments, ", "

    "#{variable}(#{arguments})"
  end
end
