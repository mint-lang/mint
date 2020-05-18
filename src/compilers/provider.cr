module Mint
  class Compiler
    def _compile(node : Ast::Provider) : String
      constructor =
        compile_constructor node

      states =
        compile node.states

      functions =
        compile node.functions

      body =
        [constructor] + states + functions

      name =
        js.class_of(node)

      js.provider(name, body)
    end
  end
end
