module Mint
  class Compiler2
    def compile(node : Ast::Pipe) : Compiled
      compile node.call
    end
  end
end
