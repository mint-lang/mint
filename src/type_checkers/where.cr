module Mint
  class TypeChecker
    def check(node : Ast::Where) : Checkable
      check node.statements

      NEVER
    end
  end
end
