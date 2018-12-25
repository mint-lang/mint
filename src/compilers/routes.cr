module Mint
  class Compiler
    def _compile(node : Ast::Routes) : String
      routes =
        compile node.routes, ", "

      "_program.addRoutes([#{routes}])"
    end
  end
end
