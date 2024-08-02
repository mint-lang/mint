module Mint
  class Compiler
    def compile(node : Ast::ArrayLiteral) : Compiled
      compile node do
        js.array(compile(node.items))
      end
    end
  end
end
