module Mint
  class TypeChecker
    type_error RecordNotFoundMatchingRecord

    def check(node : Ast::Record) : Checkable
      check node, false
    end

    def check(node : Ast::Record, for_checking : Bool) : Checkable
      fields =
        node
          .fields
          .map { |field| {field.key.value, resolve(field, for_checking)} }
          .to_h

      record =
        records.find(&.==(fields))

      if record
        types[node] = record
      else
        if for_checking
          record = Record.new("", fields)
        else
          raise RecordNotFoundMatchingRecord, {
            "structure" => Record.new("", fields),
            "node"      => node,
          }
        end
      end

      record
    end
  end
end
