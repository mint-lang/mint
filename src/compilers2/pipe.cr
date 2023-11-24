module Mint
  class Compiler2
    def compile(node : Ast::Pipe) : Compiled
      compile node do
        compile node.call
      end
    end
  end
end
