module Mint
  class TypeChecker
    def check(node : Ast::UnaryMinus) : Checkable
      expression =
        resolve node.expression

      error :unary_minus_not_number do
        block "An unary minuses expression must evaluate to number."
        expected NUMBER, expression
        snippet node
      end unless Comparer.compare(NUMBER, expression)

      expression
    end
  end
end
