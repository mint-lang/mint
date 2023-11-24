module Mint
  class Compiler2
    def compile(node : Ast::Interpolation) : Compiled
      compile node.expression
    end
  end
end
