module Mint
  class TypeChecker
    def check(node : Ast::Block) : Checkable
      scope node.statements.reject(Ast::Comment) do
        resolve node.statements
      end

      last =
        node
          .statements
          .reject(Ast::Comment)
          .sort_by! { |item| resolve_order.index(item) || -1 }
          .last

      cache[last]
    end
  end
end
