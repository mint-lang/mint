module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Type
      types[node] = resolve node.expression
    end
  end
end
