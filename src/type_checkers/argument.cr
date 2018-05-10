module Mint
  class TypeChecker
    def check(node : Ast::Argument) : Type
      resolve_type(check(node.type))
    end
  end
end
