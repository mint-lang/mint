module Mint
  class TypeChecker
    def check(node : Ast::CssFontFace) : Checkable
      resolve node.definitions

      NEVER
    end
  end
end
