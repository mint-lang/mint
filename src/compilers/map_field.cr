module Mint
  class Compiler
    def compile(node : Ast::MapField)
      compile node do
        js.array([
          compile(node.key),
          compile(node.value),
        ])
      end
    end
  end
end
