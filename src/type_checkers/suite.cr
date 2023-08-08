module Mint
  class TypeChecker
    def check(node : Ast::Suite)
      resolve node.name
      resolve node.tests

      VOID
    end
  end
end
