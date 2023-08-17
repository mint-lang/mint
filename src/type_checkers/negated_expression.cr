module Mint
  class TypeChecker
    def check(node : Ast::NegatedExpression) : Checkable
      expression =
        resolve node.expression

      error :negated_expression_not_bool do
        block "A negated expressions expression must evaluate to bool."
        expected BOOL, expression
        snippet "The expression is here:", node
      end unless Comparer.compare(BOOL, expression)

      expression
    end
  end
end
