module Mint
  class Compiler
    def _compile(node : Ast::Pipe) : Codegen::Node
      compile node.call
    end
  end
end
