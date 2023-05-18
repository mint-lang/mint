module Mint
  class TypeChecker
    def check(node : Ast::CssSelector) : Checkable
      resolve node.body

      VOID
    end
  end
end
