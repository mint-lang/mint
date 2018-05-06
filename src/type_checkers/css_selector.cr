module Mint
  class TypeChecker
    def check(node : Ast::CssSelector) : Type
      check node.definitions

      NEVER
    end
  end
end
