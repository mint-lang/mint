module Mint
  class TypeChecker
    def check(node : Ast::CssMedia) : Checkable
      resolve node.definitions

      NEVER
    end
  end
end
