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
      when Record
        type.fields.all? do |_, value|
          check_decode value
        end
      when Tags
        type.options.all? { |value| check_decode value }
      when Variable
        false
      else
        if definition = ast.type_definitions.find(&.name.value.==(type.name))
          case definition.fields
          in Array(Ast::TypeDefinitionField)
            unreachable! "Tried to check if type #{type.to_mint} is decodeable!"
          in Array(Ast::TypeVariant)
            definition_type =
              resolve(definition)

            if unified = Comparer.compare(type, definition_type)
              unified.parameters.all? do |value|
                check_decode value
              end
            else
              false
            end
          end
        else
          case type.name
          when "Just", "Ok", "Err"
            if type.parameters.size == 1
              check_decode type.parameters.first
            else
              false
            end
          when "String", "Time", "Number", "Bool", "Object", "Nothing"
            true
          when "Map"
            check_decode(type.parameters.first) &&
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
end
