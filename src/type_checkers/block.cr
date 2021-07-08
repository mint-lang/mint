module Mint
  class TypeChecker
    def check(node : Ast::Block) : Checkable
      statements =
        node.statements.reject(Ast::Comment)

      scope statements do
        resolve node.statements
      end

      last =
        cache[statements.last]

      if node.async? && last.name != "Promise"
        Type.new("Promise", [last] of Checkable)
      else
        last
      end
    end
  end
end
