module Mint
  class Compiler
    def compile(node : Ast::With) : String
      ast.modules.find(&.name.==(node.name))

      compile node.body
    end
  end
end
