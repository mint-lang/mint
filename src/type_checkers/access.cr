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
      # raise AccessNotRecord, {
      #   "object" => target,
      #   "node"   => node,
      # } unless target.is_a?(Record)

      new_target =
        case target
        in TypeChecker::Record
          target.fields[node.field.value]?
        in TypeChecker::Type
          functions =
            ast
              .unified_modules
              .flat_map do |item|
                item
                  .functions
                  .select(&.name.value.==(node.field.value))
                  .select do |function|
                    next unless argument = function.arguments.last?

                    resolved_type =
                      resolve argument.type

                    Comparer.compare(target, resolved_type)
                  end
                  .map { |function| {item, function} }
              end

          case functions.size
          when 0
            # There is no function
            raise TypeError, {
              "node" => node,
            }
          when 1
            item, function = functions.first
            lookups[node.field] = item
            resolve item

            type =
              scope(item) do
                resolve function
              end

            case type
            when TypeChecker::Type
              result_type = Type.new(type.name, type.parameters[0..-2])
              result_type.optional_count = [0, type.optional_count - 1].max
              result_type
            else
              type
            end
          else
            # Ambigous access
            raise TypeError, {
              "node" => node,
            }
          end
        in TypeChecker::Variable
          # We cannot access on a type variable, should not happen though
          raise TypeError, {
            "node" => node,
          }
        end

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
