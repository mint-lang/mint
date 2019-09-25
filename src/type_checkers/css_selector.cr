module Mint
  class TypeChecker
    def check(node : Ast::CssSelector) : Checkable
      resolve node.body

      NEVER
    end
  end
end
