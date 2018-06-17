module Mint
  class TypeChecker
    def check(node : Ast::Argument) : Checkable
      resolve_type(resolve(node.type))
    end
  end
end
