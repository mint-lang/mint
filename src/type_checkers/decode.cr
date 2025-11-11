module Mint
  class TypeChecker
    def check(node : Ast::Decode) : Checkable
      type =
        resolve node.type

      error! :decode_complex_type do
        snippet "This type cannot be automatically decoded:", type
        snippet "The decode question is here:", node
      end unless check_decode(type)

      result_type =
        Tags.new([
          Type.new("Err", [OBJECT_ERROR] of Checkable),
          Type.new("Ok", [type] of Checkable),
        ] of Checkable)

      if item = node.expression
        expression =
          resolve item

        error! :decode_expected_object do
          block do
            text "Only the"
            bold %("Object")
            text "type can be decoded but you tried to decode:"
          end

          snippet expression
          snippet "The decode question is here:", node
        end unless Comparer.compare(expression, OBJECT)

        result_type
      else
        Type.new("Function", [OBJECT, result_type] of Checkable)
      end
    end

    def check_decode(type : Checkable)
      case type
      in Type
        type.parameters.all? { |item| check_decode(item) }
      in Record
        type.fields.all? do |_, value|
          check_decode value
        end
      in Tags
        type.options.all? { |value| check_decode value }
      in Variable
        false
      end
    end
  end
end
