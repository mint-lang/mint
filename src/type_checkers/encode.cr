module Mint
  class TypeChecker
    type_error EncodeComplexType

    def check(node : Ast::Encode) : Checkable
      data =
        node.expression

      expression =
        case data
        when Ast::Record
          begin
            resolve data
          rescue RecordNotFoundMatchingRecord
          end
        else
          resolve data
        end

      raise EncodeComplexType, {
        "got"  => expression,
        "node" => node,
      } if expression && !check_decode(expression)

      OBJECT
    end
  end
end
