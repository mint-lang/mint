module Mint
  class TypeChecker
    def check(node : Ast::Type) : Checkable
      resolve_record_definition(node.name.value) ||
        component_records.values.find(&.name.==(node.name.value)) || begin
        if definition = ast.type_definitions.find(&.name.value.==(node.name.value))
          resolve(definition)
        end

        parameters =
          resolve node.parameters

        Comparer.normalize(Type.new(node.name.value, parameters))
      end
    end
  end
end
