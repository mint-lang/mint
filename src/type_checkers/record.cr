module Mint
  class TypeChecker
    def check(node : Ast::Record, should_create_record : Bool = false) : Checkable
      fields =
        node
          .fields
          .compact_map do |field|
            next unless key = field.key
            {key.value, resolve(field, should_create_record)}
          end
          .to_h

      record =
        records.find(&.==(fields))

      record = create_record(fields) if should_create_record && !record

      error! :record_not_found_matching_record_definition do
        block "I could not find a record that matches this structure:"

        snippet Record.new("", fields)
        snippet "It was used here:", node
      end unless record

      node.fields.each do |field|
        record_field_lookup[field] = record.name
      end

      record
    end
  end
end
