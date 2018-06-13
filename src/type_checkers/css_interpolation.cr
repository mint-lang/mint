module Mint
  class TypeChecker
    def check(node : Ast::CssInterpolation) : Type
      resolve node.expression
    end
  end
end
