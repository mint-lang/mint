module Mint
  class TypeChecker
    def check(node : Ast::Access) : Checkable
      target =
        resolve node.lhs

      error :access_not_record do
        snippet "You are trying to access a field on an object which is not a record:", target
        snippet node
      end unless target.is_a?(Record)

      new_target = target.fields[node.field.value]?

      error :access_field_not_found do
        block do
          text "The accessed field"
          code node.field.value
          text "does not exists on the entity:"
        end

        snippet target
        snippet "The access is here:", node
      end unless new_target

      if item = component_records.find(&.last.==(target))
        component, _ = item

        refs =
          component.refs.reduce({} of String => Ast::Node) do |memo, (variable, ref)|
            case ref
            when Ast::HtmlComponent
              component_records
                .find(&.first.name.value.==(ref.component.value))
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
