module Mint
  class TypeChecker
    def check(node : Ast::TypeVariable) : Checkable
      Variable.new(node.value)
    end
  end
end
