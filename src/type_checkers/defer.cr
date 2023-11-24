module Mint
  class TypeChecker
    def check(node : Ast::Defer) : Checkable
      type =
        resolve node.body

      Type.new("Deferred", [type] of Checkable)
    end
  end
end
