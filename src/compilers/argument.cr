module Mint
  class Compiler
    def compile(node : Ast::Argument) : String
      node.name.value
    end
  end
end
