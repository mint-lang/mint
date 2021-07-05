module Mint
  class Compiler
    def _compile(node : Ast::NumberLiteral) : Codegen::Node
      Codegen.symbol_mapped(node, node.static_value)
    end
  end
end
