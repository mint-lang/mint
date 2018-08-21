module Mint
  class Compiler
    def _compile(node : Ast::Provider) : String
      body =
        compile node.functions, "\n\n"

      name =
        underscorize(node.name)

      "const $#{name} = new (class extends Provider {\n#{body}\n})"
    end
  end
end
