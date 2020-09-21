module Mint
  class TypeChecker
    type_error RecordNotFoundMatchingRecordDefinition

    def check(node : Ast::Record, should_create_record : Bool = false) : Checkable
      fields =
        node
          .fields
          .to_h { |field| {field.key.value, resolve(field, should_create_record)} }

      if node.is_a?(Ast::EnumRecord)
        params =
          fields.each_with_object({} of String => Checkable) do |(key, type), memo|
            memo[key] = type
          end

        Record.new("", params)
      else
        record =
          records.find(&.==(fields))

        record = create_record(fields) if should_create_record && !record

        raise RecordNotFoundMatchingRecordDefinition, {
          "structure" => Record.new("", fields),
          "node"      => node,
        } unless record

        types[node] = record

        node.fields.each do |field|
          record_field_lookup[field] = record.name
        end

        record
      end
    end
  end
end
