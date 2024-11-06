module Mint
  class Compiler
    def compile(node : Ast::ReturnCall) : Compiled
      compile node do
        js.return compile(node.expression)
      end
    end
  end
end
