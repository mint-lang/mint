module Mint
  class Compiler2
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
