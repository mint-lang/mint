module Mint
  class Compiler
    def _compile(node : Ast::ArrayLiteral) : Codegen::Node
      items =
        compile node.items, ", "

      Codegen.join ["[", items, "]"]
    end
  end
end
