module Mint
  class Compiler
    def _compile(node : Ast::Module) : String
      name =
        js.class_of(node)

      body =
        compile node.functions

      js.const name, js.iic(body)
    end
  end
end
