module Mint
  class TypeChecker
    def check(node : Ast::CaseBranch, condition : Checkable) : Checkable
      type =
        node.match.try do |item|
          variables =
            destructure(item, condition)

          scope(variables) do
            resolve(node.expression)
          end
        end || resolve(node.expression)

      if node.expression.is_a?(Array(Ast::CssDefinition))
        VOID
      else
        type.as(Checkable)
      end
    end
  end
end
