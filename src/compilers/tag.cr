module Mint
  class Compiler
    def compile(node : Ast::Type) : Compiled
      js.string(node.name.value)
    end
  end
end
