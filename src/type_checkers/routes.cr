module Mint
  class TypeChecker
    def check(node : Ast::Routes) : Checkable
      resolve node.routes

      VOID
    end
  end
end
