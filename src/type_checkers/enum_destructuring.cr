module Mint
  class TypeChecker
    def check(node : Ast::EnumDestructuring) : Checkable
      entity =
        ast.enums.find(&.name.==(node.name))

      raise TypeError, {"node" => node} unless entity

      option =
        entity.options.find(&.value.==(node.option))

      raise TypeError, {"node" => node} unless option

      node.parameters.each_with_index do |param, index|
        raise TypeError, {"node" => param} unless option.parameters[index]?
      end

      resolve entity
    end
  end
end
