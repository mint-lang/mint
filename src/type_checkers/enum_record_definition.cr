module Mint
  class TypeChecker
    def check(node : Ast::EnumRecordDefinition) : Checkable
      fields =
        node
          .fields
          .to_h { |field| {field.key.value, resolve(field).as(Checkable)} }

      mappings =
        node
          .fields
          .to_h { |field| {field.key.value, field.mapping.try(&.string_value)} }

      Record.new("", fields, mappings)
    end
  end
end
