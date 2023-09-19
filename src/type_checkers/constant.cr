module Mint
  class TypeChecker
    def check(node : Ast::Constant) : Checkable
      resolve node.expression
    end
  end
end
