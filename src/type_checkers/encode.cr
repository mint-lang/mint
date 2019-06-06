module Mint
  class TypeChecker
    type_error EncodeComplexType

    def check(node : Ast::Encode) : Checkable
      expression =
        node.expression.try do |item|
          case item
          when Ast::Record
            resolve item, true
          else
            resolve item
          end
        end

      raise EncodeComplexType, {
        "got"  => expression,
        "node" => node,
      } unless check_decode(expression)

      OBJECT
    end
  end
end
