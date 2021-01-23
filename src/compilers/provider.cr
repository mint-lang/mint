module Mint
  class Compiler
    def _compile(node : Ast::Provider) : String
      functions =
        compile node.functions

      states =
        compile node.states

      gets =
        compile node.gets

      constructor =
        compile_constructor node

      body =
        [constructor] + states + gets + functions

      name =
        js.class_of(node)

      js.provider(name, body)
    end
  end
end
