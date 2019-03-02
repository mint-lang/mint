module Mint
  class TypeChecker
    type_error AccessFieldNotRecord
    type_error AccessFieldNotFound
    type_error AccessNotRecord

    def check(node : Ast::Access) : Checkable
      first =
        lookup node.fields.first

      case first
      when Ast::Component
        resolve node.fields.first

        scope first do
          second =
            lookup node.fields[1]

          raise AccessFieldNotRecord, {
            "field"  => node.fields[1].value,
            "object" => second,
            "node"   => node.fields[1],
          } unless second

          resolved =
            resolve node.fields[1]

          lookups[node.fields[1]] = second if second.is_a?(Ast::Node)

          if resolved.is_a?(Record)
            check_record_access(node.fields[1], node, 2)
          else
            resolved
          end
        end
      when Nil
        resolve node.fields.first
      else
        check_record_access(node.fields.first, node, 1)
      end
    end

    def check_record_access(first, node, from) : Checkable
      target =
        resolve first

      raise AccessNotRecord, {
        "object" => target,
        "node"   => node,
      } unless target.is_a?(Record)

      node.fields[from..node.fields.size].each do |field|
        case target
        when Record
          new_target = target.fields[field.value]?

          raise AccessFieldNotFound, {
            "field"  => field.value,
            "target" => target,
            "node"   => field,
          } unless new_target

          record_field_lookup[field] = target.name

          target = new_target
        else
          raise AccessFieldNotRecord, {
            "field"  => field.value,
            "object" => target,
            "node"   => field,
          }
        end
      end

      target
    end
  end
end
