module Mint
  class TypeChecker
    def check(node : Ast::Routes) : Type
      check node.routes

      NEVER
    end
  end
end
