module Mint
  class TypeChecker
    def check(node : Ast::Suite)
      scope node do
        resolve node.name
        resolve node.tests
      end
      NEVER
    end
  end
end
