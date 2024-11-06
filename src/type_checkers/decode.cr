module Mint
  class TypeChecker
    def check(node : Ast::Decode) : Checkable
      type =
        resolve node.type

      error! :decode_complex_type do
        snippet "This type cannot be automatically decoded:", type

        snippet(
          "Only these types and records containing them cantext be " \
          "automatically decoded:",
          <<-MINT
          Map(String, a)
          Array(a)
          Maybe(a)
          String
          Number
          Object
          Time
          Bool
          MINT
        )

        snippet "The decode question is here:", node
      end unless check_decode(type)

      result_type =
        Type.new("Result", [OBJECT_ERROR, type] of Checkable)

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
      when Record
        type.fields.all? do |_, value|
          check_decode value
        end
      when Variable
        false
      else
        case type.name
        when "String", "Time", "Number", "Bool", "Object"
          true
        when "Map"
          type.parameters.first.name == "String" &&
            type.parameters.first.parameters.size == 0 &&
            check_decode(type.parameters.last)
        when "Tuple"
          type.parameters.all? { |item| check_decode(item) }
        when "Array", "Maybe"
          if type.parameters.size == 1
            check_decode type.parameters.first
          else
            false
          end
        else
          false
        end
      end
    end
  end
end
