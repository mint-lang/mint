module Mint
  class TypeChecker
    type_error AccessUnsafeComponent
    type_error AccessFieldNotFound
    type_error AccessNotRecord

    def check(node : Ast::Access) : Checkable
      target =
        resolve node.lhs

      if node.safe? && target.name == "Maybe"
        Type.new("Maybe", [check_access(node, target.parameters[0])])
      else
        check_access(node, target)
      end
    end

    def check_access(node, target) : Checkable
      raise AccessNotRecord, {
        "object" => target,
        "node"   => node,
      } unless target.is_a?(Record)

      new_target = target.fields[node.field.value]?

      raise AccessFieldNotFound, {
        "field"  => node.field.value,
        "node"   => node.field,
        "target" => target,
      } unless new_target

      if item = component_records.find(&.last.==(target))
        refs =
          item[0].refs.reduce({} of String => Ast::Node) do |memo, (variable, ref)|
            case ref
            when Ast::HtmlComponent
              component_records
                .find(&.first.name.==(ref.component.value))
                .try do |entity|
                  memo[variable.value] = entity.first
                end
            when Ast::HtmlElement
              memo[variable.value] = ref
            end

            memo
          end

        lookups[node.field] =
          (item[0].gets.find(&.name.value.==(node.field.value)) ||
            item[0].functions.find(&.name.value.==(node.field.value)) ||
            item[0].properties.find(&.name.value.==(node.field.value)) ||
            refs[node.field.value]? ||
            item[0].states.find(&.name.value.==(node.field.value))).not_nil!

        scope(item[0]) do
          resolve lookups[node.field]
        end
      else
        record_field_lookup[node.field] = new_target.name
      end

      new_target
    end
  end
end
