module Mint
  class Compiler
    def _compile(node : Ast::Constant) : String
      name =
        js.variable_of(node)

      value =
        compile node.value

      js.get(name, "return #{value};")
    end
  end
end
