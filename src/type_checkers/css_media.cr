module Mint
  class TypeChecker
    def check(node : Ast::CssMedia) : Type
      resolve node.definitions

      NEVER
    end
  end
end
