module Mint
  class Compiler
    def _compile(node : Ast::Module) : String
      name =
        js.class_of(node)

      body =
        compile node.functions

      js.module(name, body)
    end
  end
end
