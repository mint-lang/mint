module Mint
  class Compiler
    def compile(node : Ast::Pipe) : Compiled
      compile node do
        compile node.call
      end
    end
  end
end
