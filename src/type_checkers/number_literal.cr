module Mint
  class TypeChecker
    def check(node : Ast::NumberLiteral) : Type
      NUMBER
    end
  end
end
