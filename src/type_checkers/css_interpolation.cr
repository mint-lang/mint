module Mint
  class TypeChecker
    def check(node : Ast::CssInterpolation) : Type
      check node.expression
    end
  end
end
