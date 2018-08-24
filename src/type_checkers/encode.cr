module Mint
  class TypeChecker
    type_error EncodeComplexType

    def check(node : Ast::Encode) : Checkable
      data =
        node.expression

      expression =
        case data
        when Ast::Record
          resolve data, true
        else
          resolve data
        end

      raise EncodeComplexType, {
        "got"  => expression,
        "node" => node,
      } unless check_decode(expression)

      OBJECT
    end
  end
end
