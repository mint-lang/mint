module Mint
  class TypeChecker
    type_error AccessFieldNotFound
    type_error AccessNotRecord

    def check(node : Ast::Access) : Checkable
      target =
        resolve node.lhs

      check_access(node, target)
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
        component, _ = item

        refs =
          component.refs.reduce({} of String => Ast::Node) do |memo, (variable, ref)|
            case ref
            when Ast::HtmlComponent
              component_records
                .find(&.first.name.==(ref.component.value))
                .try do |entity|
                  memo[variable.value] = entity.first
                end
            when Ast::HtmlElement
              memo[variable.value] = variable
            end

            memo
          end

        lookups[node.field] =
          (component.gets.find(&.name.value.==(node.field.value)) ||
            component.functions.find(&.name.value.==(node.field.value)) ||
            component.properties.find(&.name.value.==(node.field.value)) ||
            refs[node.field.value]? ||
            component.states.find(&.name.value.==(node.field.value))).not_nil!

        scope(component) do
          resolve lookups[node.field]
        end
      else
        record_field_lookup[node.field] = new_target.name
      end

      new_target
    end
  end
end
