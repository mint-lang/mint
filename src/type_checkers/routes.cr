module Mint
  class TypeChecker
    def check(node : Ast::Routes) : Type
      resolve node.routes

      NEVER
    end
  end
end
