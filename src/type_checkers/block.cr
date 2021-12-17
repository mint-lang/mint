module Mint
  class TypeChecker
    def check(node : Ast::Block) : Checkable
      statements =
        node.statements.reject(Ast::Comment)

      scope statements do
        resolve node.statements
      end

      last =
        statements.last

      last_type = cache[last]

      if node.async?
        if Comparer.compare(last_type, PROMISE)
          last_type
        else
          Type.new("Promise", [cache[last]] of Checkable)
        end
      else
        cache[last]
      end
    end
  end
end
