module Mint
  class TypeChecker
    def check(node : Ast::EnumOption) : Checkable
      parameters =
        resolve node.parameters

      Type.new(node.value, parameters)
    end
  end
end
