module Mint
  class Compiler
    def _compile(node : Ast::Module) : String
      body =
        compile node.functions, "\n\n"

      name =
        underscorize node.name

      "const $#{name} = new(class {\n#{body.indent}\n})"
    end
  end
end
