module Mint
  class Compiler
    def compile(node : Ast::Interpolation) : Compiled
      compile node do
        compile node.expression
      end
    end
  end
end
