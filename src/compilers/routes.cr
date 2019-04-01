module Mint
  class Compiler
    def _compile(node : Ast::Routes) : String
      routes =
        compile node.routes

      "_program.addRoutes(#{js.array(routes)})"
    end
  end
end
