module Mint
  class TypeChecker
    type_error UnaryMinusNotNumber

    def check(node : Ast::UnaryMinus) : Checkable
      expression =
        resolve node.expression

      raise UnaryMinusNotNumber, {
        "got"      => expression,
        "expected" => NUMBER,
        "node"     => node,
      } unless Comparer.compare(NUMBER, expression)

      expression
    end
  end
end
