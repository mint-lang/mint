module Mint
  class TypeChecker
    type_error AccessUnsafeComponent
    type_error AccessFieldNotFound
    type_error AccessNotRecord

    def check(node : Ast::Access) : Checkable
      check_component_access(node) || begin
        target =
          resolve node.lhs

        if node.safe && target.name == "Maybe"
          Type.new("Maybe", [check_access(node, target.parameters[0])])
        else
          check_access(node, target)
        end
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

      record_field_lookup[node.field] = new_target.name

      new_target
    end

    def check_component_access(node)
      node.lhs.try do |lhs|
        case lhs
        when Ast::Variable
          first =
            lookup lhs

          case first
          when Ast::Component
            raise AccessUnsafeComponent, {
              "name" => node.field.value,
              "node" => node,
            } unless node.safe

            resolve lhs

            scope first do
              second =
                lookup node.field

              raise AccessFieldNotFound, {
                "field" => node.field.value,
                "node"  => node.field,
              } unless second

              resolved =
                resolve node.field

              lookups[node.field] = second if second.is_a?(Ast::Node)

              Type.new("Maybe", [resolved])
            end
          end
        end
      end
    end
  end
end
