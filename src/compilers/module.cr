module Mint
  class Compiler
    def _compile(node : Ast::Module) : String
      body =
        compile node.functions, "\n\n"

      name =
        underscorize node.name

      <<-A
      const $#{name} = new(class extends Module {
      #{body.indent}
      })
      A
    end
  end
end
