module Mint
  class TypeChecker
    def check(node : Ast::CssKeyframes) : Checkable
      resolve node.selectors

      VOID
    end
  end
end
