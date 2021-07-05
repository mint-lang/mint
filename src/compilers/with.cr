module Mint
  class Compiler
    def _compile(node : Ast::With) : Codegen::Node
      compile node.body
    end
  end
end
