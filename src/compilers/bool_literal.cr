module Mint
  class Compiler
    def _compile(node : Ast::BoolLiteral) : String
      node.value.to_s
    end
  end
end
