module Mint
  class TypeChecker
    def check(node : Ast::Style) : Type
      resolve node.definitions
      resolve node.selectors
      resolve node.medias

      NEVER
    end
  end
end
