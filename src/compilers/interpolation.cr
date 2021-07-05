module Mint
  class Compiler
    def _compile(node : Ast::Interpolation) : Codegen::Node
      compile node.expression
    end
  end
end
