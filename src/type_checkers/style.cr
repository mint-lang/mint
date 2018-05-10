module Mint
  class TypeChecker
    def check(node : Ast::Style) : Type
      check node.definitions
      check node.selectors
      check node.medias

      NEVER
    end
  end
end
