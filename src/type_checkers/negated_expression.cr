module Mint
  class TypeChecker
    def check(node : Ast::NegatedExpression) : Checkable
      expression =
        resolve node.expression

      error! :negated_expression_not_bool do
        snippet "A negated expressions expression must evaluate to a " \
                "boolean, but it is:", expression
        snippet "The negated expression in question is here:", node
      end unless Comparer.compare(BOOL, expression)

      expression
    end
  end
end
