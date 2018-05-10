module Mint
  class TypeChecker
    def check(node : Ast::BoolLiteral) : Type
      BOOL
    end
  end
end
