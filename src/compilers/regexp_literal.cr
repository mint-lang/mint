module Mint
  class Compiler
    def _compile(node : Ast::RegexpLiteral) : String
      node.static_value
    end
  end
end
