module Mint
  class Compiler
    def _compile(node : Ast::With) : String
      compile node.body
    end
  end
end
