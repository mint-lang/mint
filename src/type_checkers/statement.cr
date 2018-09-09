module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Checkable
      check_variable node.name

      types[node] = resolve node.expression
    end
  end
end
