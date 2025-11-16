module Mint
  class TypeChecker
    def check(node : Ast::TypeDefinitionField) : Checkable
      resolve(node.type).tap(&.label=(node.key.value))
    end
  end
end
