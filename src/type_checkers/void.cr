module Mint
  class TypeChecker
    def check(node : Ast::Void) : Checkable
      VOID
    end
  end
end
