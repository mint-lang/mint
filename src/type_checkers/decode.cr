module Mint
  class TypeChecker
    type_error DecodeExpectedObject
    type_error DecodeComplexType

    def check(node : Ast::Decode) : Checkable
      type =
        resolve node.type

      raise "" unless type

      raise DecodeComplexType, {
        "got"  => type,
        "node" => node,
      } unless check_decode(type)

      types[node] = type

      result_type =
        Type.new("Result", [OBJECT_ERROR, type] of Checkable)

      if item = node.expression
        expression =
          resolve item

        raise DecodeExpectedObject, {
          "expected" => OBJECT,
          "got"      => expression,
          "node"     => node,
        } unless Comparer.compare(expression, OBJECT)

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
