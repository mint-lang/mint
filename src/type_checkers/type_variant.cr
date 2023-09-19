module Mint
  class TypeChecker
    def check(node : Ast::TypeVariant) : Checkable
      parameters =
        resolve node.parameters

      Type.new(node.value.value, parameters)
    end
  end
end
