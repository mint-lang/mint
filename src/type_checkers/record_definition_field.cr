module Mint
  class TypeChecker
    def check(node : Ast::RecordDefinitionField) : Checkable
      resolve node.type
    end
  end
end
