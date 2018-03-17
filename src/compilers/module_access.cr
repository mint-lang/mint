class Compiler
  def compile(node : Ast::ModuleAccess) : String
    name =
      underscorize node.name

    variable =
      node.variable.value

    "$#{name}.#{variable}"
  end
end
