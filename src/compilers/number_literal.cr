module Mint
  class Compiler
    def _compile(node : Ast::NumberLiteral) : String
      if node.float
        node.value.to_s
      else
        node.value.to_i64.to_s
      end
    end
  end
end
