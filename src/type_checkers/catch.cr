module Mint
  class TypeChecker
    def check(node : Ast::Catch) : Checkable
      resolve node.expression
    end
  end
end
