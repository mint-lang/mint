module Mint
  class Compiler
    def _compile(node : Ast::Routes) : String
      routes =
        compile node.routes

      "_program.addRoutes(#{js.array(routes)})"
    end

    def _compile_service_worker(node : Ast::Routes) : String
      routes =
        node.routes
          .map do |route|
            compile_service_worker route
          end

      js.array(routes)
    end
  end
end
