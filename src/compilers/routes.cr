module Mint
  class Compiler
    def _compile(node : Ast::Routes) : Codegen::Node
      routes =
        compile node.routes

      Codegen.join ["_program.addRoutes(", js.array(routes), ")"]
    end
  end
end
