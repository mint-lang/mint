module Mint
  class Compiler
    def _compile(node : Ast::TupleLiteral) : Codegen::Node
      items =
        compile node.items, ", "

      Codegen.join ["[", items, "]"]
    end
  end
end
