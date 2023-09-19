module Mint
  class TypeChecker
    def check(node : Ast::TypeDefinitionField) : Checkable
      resolve node.type
    end
  end
end
