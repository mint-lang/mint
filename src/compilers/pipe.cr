module Mint
  class Compiler
    def _compile(node : Ast::Pipe) : String
      compile node.call
    end
  end
end
