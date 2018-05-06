module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Type
      types[node] = check node.expression
    end
  end
end
