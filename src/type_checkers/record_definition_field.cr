module Mint
  class TypeChecker
    def check(node : Ast::RecordDefinitionField) : Type
      check node.type
    end
  end
end
