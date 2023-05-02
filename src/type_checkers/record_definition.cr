module Mint
  class TypeChecker
    def check(node : Ast::RecordDefinition) : Checkable
      check_global_types node.name.value, node

      fields =
        node
          .fields
          .to_h { |field| {field.key.value, resolve(field).as(Checkable)} }

      mappings =
        node
          .fields
          .to_h { |field| {field.key.value, field.mapping.try(&.string_value)} }

      type = Record.new(node.name.value, fields, mappings)
      types[node] = type

      type
    end
  end
end
