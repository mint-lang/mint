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

      keys =
        node.fields.compact_map(&.key.try(&.value))

      record =
        ast.type_definitions.find_value do |definition|
          case items = definition.fields
          when Array(Ast::TypeDefinitionField)
            if items.all?(&.key.value.in?(keys))
              Comparer.compare(resolve(definition), Record.new("", fields), expand: true)
            end
          end
        end

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
