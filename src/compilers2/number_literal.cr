module Mint
  class Compiler2
    def compile(node : Ast::NumberLiteral) : Compiled
      [static_value(node).to_s] of Item
    end
  end
end
