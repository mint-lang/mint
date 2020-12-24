module Mint
  class Compiler
    def _compile(node : Ast::BoolLiteral) : Codegen::Node
      Codegen.symbol_mapped(node, node.value.to_s)
    end
  end
end
