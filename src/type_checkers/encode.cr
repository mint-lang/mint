module Mint
  class TypeChecker
    type_error EncodeComplexType

    def check(node : Ast::Encode) : Checkable
      expression =
        resolve node.expression

      raise EncodeComplexType, {
        "got"  => expression,
        "node" => node,
      } unless check_decode(expression)

      OBJECT
    end
  end
end
