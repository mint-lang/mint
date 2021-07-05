module Mint
  class Compiler
    def _compile(node : Ast::Argument) : Codegen::Node
      Codegen.symbol_mapped(node, js.variable_of(node))
    end
  end
end
