module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Checkable
      types[node] = resolve node.expression
    end
  end
end
