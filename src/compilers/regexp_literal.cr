module Mint
  class Compiler
    def _compile(node : Ast::RegexpLiteral) : Codegen::Node
      node.static_value
    end
  end
end
