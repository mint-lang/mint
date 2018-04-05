class Compiler
  def compile(node : Ast::Routes) : String
    routes =
      compile node.routes, ", "

    "program.addRoutes([#{routes}])"
  end
end
