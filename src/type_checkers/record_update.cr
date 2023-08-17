module Mint
  class TypeChecker
    def check(node : Ast::RecordUpdate) : Checkable
      target =
        resolve node.expression

      target_node =
        case item = node.expression
        when Ast::Variable
          lookup(item).not_nil!
        else
          item
        end

      error :record_update_not_updating_record do
        block do
          text "The"
          bold "target of a record update"
          text "is not a record, instead it is:"
        end

        snippet target

        snippet "Here is where you want to update it:", node
        snippet "Here is where the target is defined:", target_node
      end unless target.is_a?(Record)

      node.fields.each do |field|
        type =
          resolve field

        record_field_lookup[field] = target.name

        value_type =
          target.fields[field.key.value]?

        error :record_update_not_found_key do
          block do
            text "The field"
            bold field.key.value
            text "does not exists on the target record:"
          end

          snippet target
          snippet field
        end unless value_type

        error :record_update_type_mismatch do
          block do
            text "One of the updated fields do not match its type."
          end

          expected value_type, type

          snippet "The update is here:", field
          snippet "The target is defined here:", target_node
        end unless Comparer.compare(type, value_type)
      end

      target
    end
  end
end
