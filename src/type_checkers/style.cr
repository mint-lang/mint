module Mint
  class TypeChecker
    def check(node : Ast::Style) : Checkable
      scope node do
        resolve node.arguments
        resolve node.body
      end

      VOID
    end
  end
end
