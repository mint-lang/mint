module Mint
  class Compiler2
    def compile(node : Ast::Routes) : Compiled
      routes =
        compile node.routes

      js.array(routes)
    end
  end
end
