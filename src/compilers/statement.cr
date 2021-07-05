module Mint
  class Compiler
    def _compile(node : Ast::Statement) : Codegen::Node
      Codegen.source_mapped(node, compile node.expression)
    end
  end
end
