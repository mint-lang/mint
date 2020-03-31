module Mint
  class TypeChecker
    def check(node : Ast::CssNestedAt) : Checkable
      resolve node.body

      NEVER
    end
  end
end
