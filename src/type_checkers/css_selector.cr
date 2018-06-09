module Mint
  class TypeChecker
    def check(node : Ast::CssSelector) : Type
      resolve node.definitions

      NEVER
    end
  end
end
