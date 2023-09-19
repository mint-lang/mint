module Mint
  class TypeChecker
    def check(node : Ast::UnaryMinus) : Checkable
      expression =
        resolve node.expression

      error! :unary_minus_not_number do
        snippet "An unary minuses expression must evaluate to number. " \
                "Instead it is:", expression
        snippet "The unary minus in question is here:", node
      end unless Comparer.compare(NUMBER, expression)

      expression
    end
  end
end
