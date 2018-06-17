module Mint
  class TypeChecker
    def check(node : Ast::BoolLiteral) : Checkable
      BOOL
    end
  end
end
