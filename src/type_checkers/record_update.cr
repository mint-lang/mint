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

      error! :record_update_not_updating_record do
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
        next unless key = field.key

        type =
          resolve field

        record_field_lookup[field] = target.name

        value_type =
          target.fields[key.value]?

        error! :record_update_not_found_key do
          block do
            text "The field"
            bold %("#{key.value}")
            text "does not exists on the target record:"
          end

          snippet target
          snippet "Here is where you tried to assign a value to it:", field
        end unless value_type

        error! :record_update_type_mismatch do
          snippet "One of the updated fields of a record do not " \
                  "match its type:", field

          expected value_type, type

          snippet "The record is here:", target_node
        end unless Comparer.compare(type, value_type)
      end

      target
    end
  end
end
