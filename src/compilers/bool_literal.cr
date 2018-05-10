module Mint
  class Compiler
    def compile(node : Ast::BoolLiteral) : String
      node.value.to_s
    end
  end
end
