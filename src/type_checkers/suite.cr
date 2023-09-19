module Mint
  class TypeChecker
    def check(node : Ast::Suite)
      resolve node.constants
      resolve node.tests
      resolve node.name

      VOID
    end
  end
end
