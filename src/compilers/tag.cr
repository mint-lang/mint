module Mint
  class Compiler
    def compile(node : Ast::Tag) : Compiled
      js.string(node.value)
    end
  end
end
