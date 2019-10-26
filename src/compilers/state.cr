module Mint
  class Compiler
    def _compile(node : Ast::State) : String
      name =
        js.variable_of(node)

      js.get(name, "return this.state.#{name};")
    end
  end
end
