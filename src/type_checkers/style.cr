module Mint
  class TypeChecker
    def check(node : Ast::Style) : Checkable
      resolve node.body

      NEVER
    end
  end
end
