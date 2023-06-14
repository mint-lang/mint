module Mint
  class TypeChecker
    def check(node : Ast::Directives::Highlight) : Checkable
      Type.new("Tuple", [resolve(node.content), HTML] of Checkable)
    end
  end
end
