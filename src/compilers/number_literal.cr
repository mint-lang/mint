module Mint
  class Compiler
    def _compile(node : Ast::NumberLiteral) : String
      node.static_value
    end
  end
end
