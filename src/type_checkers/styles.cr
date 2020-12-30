module Mint
  class TypeChecker
    # This method is only needed so the node ends up being checked
    def check(node : Ast::Styles) : Checkable
      NEVER
    end
  end
end
