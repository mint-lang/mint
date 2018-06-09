module Mint
  class TypeChecker
    def check(node : Ast::RecordDefinitionField) : Type
      resolve node.type
    end
  end
end
