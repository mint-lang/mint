module Mint
  class TypeChecker
    def check(node : Ast::Constant) : Checkable
      resolve node.value
    end
  end
end
