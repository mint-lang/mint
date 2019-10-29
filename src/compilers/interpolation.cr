module Mint
  class Compiler
    def _compile(node : Ast::Interpolation) : String
      compile node.expression
    end
  end
end
