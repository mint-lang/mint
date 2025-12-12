module Mint
  class TypeChecker
    def check(node : Ast::Type) : Checkable
      parameters =
        resolve node.parameters

      if definition = ast.type_definitions.find(&.name.value.==(node.name.value))
        mapping =
          definition.parameters.map_with_index do |param, index|
            {param.value, parameters[index]}
          end.to_h

        Comparer.fill(resolve(definition), mapping)
      else
        component_records[node.name.value]?.try(&.last) ||
          Comparer.normalize(Type.new(node.name.value, parameters))
      end
    end
  end
end
