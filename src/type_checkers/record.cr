module Mint
  class TypeChecker
    type_error RecordNotFoundMatchingRecord

    def check(node : Ast::Record) : Checkable
      check node, false
    end

    def check(node : Ast::Record, should_create_record : Bool = false) : Checkable
      fields =
        node
          .fields
          .map { |field| {field.key.value, resolve(field)} }
          .to_h

      record =
        records.find(&.==(fields))

      record = create_record(fields) if should_create_record && !record

      raise RecordNotFoundMatchingRecord, {
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
