module Mint
  class TypeChecker
    type_error NegatedExpressionNotBool

    def check(node : Ast::NegatedExpression) : Checkable
      expression =
        resolve node.expression

      raise NegatedExpressionNotBool, {
        "got"      => expression,
        "expected" => BOOL,
      } unless Comparer.compare(BOOL, expression)

      expression
    end
  end
end
