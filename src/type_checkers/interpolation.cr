module Mint
  class TypeChecker
    def check(node : Ast::Interpolation) : Checkable
      resolve node.expression
    end
  end
end
