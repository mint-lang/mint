module Mint
  class TypeChecker
    def check(node : Ast::RecordField) : Type
      resolve node.value
    end
  end
end
