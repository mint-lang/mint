module Mint
  class TypeChecker
    type_error RecordNotFoundMatchingRecord

    def check(node : Ast::Record) : Checkable
      check node, false
    end

    def check(node : Ast::Record) : Checkable
      fields =
        node
          .fields
          .map { |field| {field.key.value, resolve(field)} }
          .to_h

      record =
        records.find(&.==(fields))

      record = create_record(fields) unless record

      types[node] = record

      # raise RecordNotFoundMatchingRecord, {
      #  "structure" => Record.new("", fields),
      #  "node"      => node,
      # }

      node.fields.each do |field|
        record_field_lookup[field] = record.name
      end

      record
    end
  end
end
