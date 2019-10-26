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
          .map do |field|
            value =
              field.mapping.try do |string_literal|
                string_literal
                  .value
                  .select(&.is_a?(String))
                  .map(&.as(String))
                  .join("")
              end

            {field.key.value, value}
          end
          .to_h

      type = Record.new(node.name, fields, mappings)
      types[node] = type

      type
    end
  end
end
