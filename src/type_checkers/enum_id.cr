module Mint
  class TypeChecker
    type_error EnumIdTypeMissing
    type_error EnumIdEnumMissing

    def check(node : Ast::EnumId) : Checkable
      parent =
        ast.enums.find(&.name.==(node.name))

      raise EnumIdTypeMissing, {
        "name" => node.name,
        "node" => node,
      } unless parent

      raise EnumIdEnumMissing, {
        "parent_name" => parent.name,
        "name"        => node.option,
        "parent"      => parent,
        "node"        => node,
      } unless parent.options.any?(&.==(node.option))

      Type.new(node.name)
    end
  end
end
