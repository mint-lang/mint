module Mint
  class Compiler
    def compile(node : Ast::With) : String
      compile node.body
    end
  end
end
