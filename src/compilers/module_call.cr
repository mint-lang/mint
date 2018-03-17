class Compiler
  def compile(node : Ast::ModuleCall) : String
    name =
      underscorize node.name

    function =
      node.function.value

    arguments =
      compile node.arguments, ", "

    "$#{name}.#{function}(#{arguments})"
  end
end
