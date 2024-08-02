module Mint
  class Compiler
    def compile(node : Ast::TupleLiteral) : Compiled
      compile node do
        js.array(compile(node.items))
      end
    end
  end
end
