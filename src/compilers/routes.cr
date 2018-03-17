class Compiler
  def compile(node : Ast::Routes) : String
    routes =
      compile node.routes, ", "

    "Mint.addRoutes([#{routes}])"
  end
end
