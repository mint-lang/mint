module Mint
  class TypeChecker
    def check(node : Ast::Where) : Type
      resolve node.expression
    end
  end
end
