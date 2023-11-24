module Mint
  class Compiler2
    def compile(node : Ast::ArrayLiteral) : Compiled
      compile node do
        js.array(compile(node.items))
      end
    end
  end
end
