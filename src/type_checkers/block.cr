module Mint
  class TypeChecker
    def check(node : Ast::Block) : Checkable
      statements =
        node.statements.reject(Ast::Comment)

      async =
        node
          .statements
          .select(Ast::Statement)
          .any?(&.await)

      scope statements do
        resolve node.statements
      end

      last =
        statements.last

      if async
        Type.new("Promise", [cache[last]] of Checkable)
      else
        cache[last]
      end
    end
  end
end
