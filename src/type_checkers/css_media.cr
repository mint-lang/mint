module Mint
  class TypeChecker
    def check(node : Ast::CssMedia) : Checkable
      resolve node.body

      NEVER
    end
  end
end
