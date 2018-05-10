module Mint
  class TypeChecker
    type_error RecordNotFoundMatchingRecord

    def check(node : Ast::Record) : Type
      fields =
        node
          .fields
          .map { |field| {field.key.value, check field} }
          .to_h

      record = records.find(&.==(fields))

      raise RecordNotFoundMatchingRecord, {
        "structure" => Record.new("", fields),
        "node"      => node,
      } unless record

      record
    end
  end
end
