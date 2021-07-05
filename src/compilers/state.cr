module Mint
  class Compiler
    def _compile(node : Ast::State) : Codegen::Node
      name =
        js.variable_of(node)

      js.get(name, Codegen.join ["return this.state.", name, ";"])
    end
  end
end
