module Mint
  class TypeChecker
    def check(node : Ast::RecordField) : Checkable
      resolve node.value
    end
  end
end
