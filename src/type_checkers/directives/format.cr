module Mint
  class TypeChecker
    def check(node : Ast::Directives::Format) : Checkable
      Type.new("Tuple", [resolve(node.content), STRING] of Checkable)
    end
  end
end
