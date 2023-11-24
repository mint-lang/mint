module Mint
  class TypeChecker
    def check(node : Ast::FieldAccess) : Checkable
      case type = resolve node.type
      when Record
        field =
          type.fields[node.name.value]?

        error! :field_access_field_not_found do
          block do
            text "The field"
            bold node.name.value
            text "does not exists on the type:"
          end

          snippet type
          snippet "The field access in question is here:", node
        end unless field

        Type.new("Function", [type, field] of Checkable)
      else
        error! :field_access_not_record do
          snippet "The type of the accessed entity is not a record:", type
          snippet "The field access in question is here:", node
        end
      end
    end
  end
end
