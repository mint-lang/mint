module Mint
  class TypeChecker
    def check(node : Ast::CssSelector) : Checkable
      resolve node.definitions

      NEVER
    end
  end
end
