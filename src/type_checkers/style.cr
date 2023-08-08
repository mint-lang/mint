module Mint
  class TypeChecker
    def check(node : Ast::Style) : Checkable
      resolve node.arguments
      resolve node.body

      VOID
    end
  end
end
