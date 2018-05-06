module Mint
  class TypeChecker
    type_error EnumIdTypeMissing
    type_error EnumIdEnumMissing

    def check(node : Ast::EnumId)
      parent =
        ast.enums.find(&.name.==(node.name))

      raise EnumIdTypeMissing, {
        "node" => node,
      } unless parent

      raise EnumIdEnumMissing, {
        "name" => node.option,
        "node" => node,
      } unless parent.options.any?(&.==(node.option))

      Type.new(node.name)
    end
  end
end
