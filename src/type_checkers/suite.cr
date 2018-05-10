module Mint
  class TypeChecker
    def check(node : Ast::Suite)
      check node.tests

      NEVER
    end
  end
end
