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

      if option.parameters.size == 1 &&
         option.parameters[0].is_a?(Ast::EnumRecordDefinition)
        fields =
          option
            .parameters[0]
            .as(Ast::EnumRecordDefinition)
            .fields

        node.parameters.each do |item|
          found = fields.find do |field|
            case item
            when Ast::TypeVariable
              item.value == field.key.value
            end
          end

          raise TypeError.new unless found
        end
      else
        node.parameters.each_with_index do |param, index|
          raise EnumDestructuringNoParameter, {
            "size"   => option.parameters.size.to_s,
            "index"  => index.to_s,
            "name"   => option.value,
            "option" => option,
            "node"   => param,
          } unless option.parameters[index]?
        end
      end

      resolve parent
    end
  end
end
