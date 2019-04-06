module Mint
  class Compiler
    def _compile(node : Ast::Provider) : String
      body =
        compile node.functions

      name =
        js.class_of(node)

      js.provider(name, body)
    end
  end
end
