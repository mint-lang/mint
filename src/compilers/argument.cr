module Mint
  class Compiler
    def _compile(node : Ast::Argument) : String
      node.name.value
    end
  end
end
