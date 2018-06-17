module Mint
  class TypeChecker
    def check(node : Ast::CssInterpolation) : Checkable
      resolve node.expression
    end
  end
end
