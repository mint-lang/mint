module Mint
  class Compiler
    def compile(node : Ast::Await) : Compiled
      compile node do
        [Await.new, " "] + defer(node.body, compile(node.body))
      end
    end
  end
end
