module Mint
  class TypeChecker
    def check(node : Ast::Routes) : Checkable
      resolve node.routes

      NEVER
    end
  end
end
