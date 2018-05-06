module Mint
  class TypeChecker
    type_error AccessFieldNotRecord
    type_error AccessFieldNotFound
    type_error AccessNotRecord

    def check(node : Ast::Access) : Type
      target =
        check node.fields.first

      raise AccessNotRecord, {
        "object" => target,
        "node"   => node,
      } unless target.is_a?(Record)

      node.fields[1..node.fields.size].each do |field|
        case target
        when Record
          new_target = target.fields[field.value]?

          raise AccessFieldNotFound, {
            "field"  => field.value,
            "target" => target,
            "node"   => field,
          } unless new_target

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
