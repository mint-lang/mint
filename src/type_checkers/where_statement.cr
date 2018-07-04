module Mint
  class TypeChecker
    def check(node : Ast::WhereStatement) : Checkable
      resolve node.expression
    end
  end
end
