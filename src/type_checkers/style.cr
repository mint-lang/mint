module Mint
  class TypeChecker
    def check(node : Ast::Style) : Checkable
      scope node do
        resolve node.arguments
        resolve node.body

        NEVER
      end
    end
  end
end
