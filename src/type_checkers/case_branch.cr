module Mint
  class TypeChecker
    def check(node : Ast::CaseBranch, condition : Checkable) : Checkable
      type =
        node.pattern.try do |item|
          variables =
            destructure(item, condition)

          variables.each do |var|
            scope.add(node, var[0], var[2])
          end

          resolve(node.expression)
        end || resolve(node.expression)

      if node.expression.is_a?(Array(Ast::CssDefinition))
        VOID
      else
        type.as(Checkable)
      end
    end
  end
end
