module Mint
  class TypeChecker
    def check(node : Ast::Argument) : Type
      resolve_type(resolve(node.type))
    end
  end
end
