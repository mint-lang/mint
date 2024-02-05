module Mint
  class TypeChecker
    def check(node : Ast::Defer) : Checkable
      component_stack.push(node)

      type =
        resolve node.body

      component_stack.delete(node)

      Type.new("Deferred", [type] of Checkable)
    end
  end
end
