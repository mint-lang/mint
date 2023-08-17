module Mint
  class TypeChecker
    def check(node : Ast::Record, should_create_record : Bool = false) : Checkable
      fields =
        node
          .fields
          .to_h { |field| {field.key.value, resolve(field, should_create_record)} }

      case node
      when Ast::EnumRecord
        params =
          fields.each_with_object({} of String => Checkable) do |(key, type), memo|
            memo[key] = type
          end

        Record.new("", params)
      else
        record =
          records.find(&.==(fields))

        record = create_record(fields) if should_create_record && !record

        error :record_not_found_matching_record_definition do
          block "I could not find a record that matches this structure:"

          snippet Record.new("", fields)
          snippet "It was used here:", node
        end unless record

        types[node] = record

        node.fields.each do |field|
          record_field_lookup[field] = record.name
        end

        record
      end
    end
  end
end
