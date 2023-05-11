module Mint
  class TypeChecker
    def check(node : Ast::CssNestedAt) : Checkable
      resolve node.body

      VOID
    end
  end
end
