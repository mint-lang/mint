module Mint
  class Compiler2
    def compile(node : Ast::ReturnCall) : Compiled
      compile node do
        js.return compile(node.expression)
      end
    end
  end
end
