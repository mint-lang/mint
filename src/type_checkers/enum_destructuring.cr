module Mint
  class TypeChecker
    type_error EnumDestructuringNoParameter
    type_error EnumDestructuringTypeMissing
    type_error EnumDestructuringEnumMissing

    def check(node : Ast::EnumDestructuring) : Checkable
      parent =
        ast.enums.find(&.name.==(node.name))

      raise EnumDestructuringTypeMissing, {
        "name" => node.name,
        "node" => node,
      } unless parent

      option =
        parent.options.find(&.value.==(node.option))

      raise EnumDestructuringEnumMissing, {
        "parent_name" => parent.name,
        "name"        => node.option,
        "parent"      => parent,
        "node"        => node,
      } unless option

      lookups[node] = option

      node.parameters.each_with_index do |param, index|
        raise EnumDestructuringNoParameter, {
          "size"   => option.parameters.size.to_s,
          "index"  => index.to_s,
          "name"   => option.value,
          "option" => option,
          "node"   => param,
        } unless option.parameters[index]?
      end

      resolve parent
    end
  end
end
