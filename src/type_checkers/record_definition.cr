module Mint
  class TypeChecker
    def check(node : Ast::RecordDefinition) : Checkable
      check_global_types node.name, node

      fields =
        node
          .fields
          .map { |field| {field.key.value, resolve(field).as(Checkable)} }
          .to_h

      mappings =
        node
          .fields
          .map { |field| {field.key.value, field.mapping.try(&.value)} }
          .to_h

      type = Record.new(node.name, fields, mappings)
      types[node] = type

      type
    end
  end
end
