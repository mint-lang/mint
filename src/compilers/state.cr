module Mint
  class Compiler
    def _compile(node : Ast::State) : String
      name =
        node.name.value

      "get #{name}() { return this.state.#{name} }"
    end
  end
end
