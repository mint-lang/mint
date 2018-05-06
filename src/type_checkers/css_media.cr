module Mint
  class TypeChecker
    def check(node : Ast::CssMedia) : Type
      check node.definitions

      NEVER
    end
  end
end
