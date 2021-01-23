module Mint
  class TypeChecker
    def check(node : Ast::CssKeyframes) : Checkable
      resolve node.selectors

      NEVER
    end
  end
end
