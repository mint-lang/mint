module Mint
  class Compiler
    def compile(node : Ast::BoolLiteral) : Compiled
      compile node do
        [node.value.to_s] of Item
      end
    end
  end
end
