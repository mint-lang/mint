module Mint
  class TypeChecker
    def check(node : Ast::Suite)
      resolve node.tests

      NEVER
    end
  end
end
