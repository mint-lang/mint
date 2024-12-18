module Mint
  class Compiler
    def compile(node : Ast::SignalValue) : Compiled
      compile node do
        compile(node.expression) + [".value"]
      end
    end
  end
end
