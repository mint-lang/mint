module Mint
  class TypeChecker
    def check(node : Ast::Where) : Checkable
      resolve node.expression
    end
  end
end
