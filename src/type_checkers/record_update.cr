module Mint
  class TypeChecker
    type_error RecordUpdateNotUpdatingRecord
    type_error RecordUpdateTypeMismatch
    type_error RecordUpdateNotFoundKey

    def check(node : Ast::RecordUpdate) : Checkable
      target =
        resolve node.variable

      target_node =
        lookup(node.variable).not_nil!

      raise RecordUpdateNotUpdatingRecord, {
        "target_node" => target_node,
        "target"      => target,
        "node"        => node,
      } unless target.is_a?(Record)

      node.fields.each do |field|
        type =
          resolve field, false

        value_type =
          target.fields[field.key.value]?

        raise RecordUpdateNotFoundKey, {
          "key"    => field.key.value,
          "target" => target,
          "node"   => field,
        } unless value_type

        raise RecordUpdateTypeMismatch, {
          "target_node" => target_node,
          "expected"    => value_type,
          "node"        => field,
          "got"         => type,
        } unless Comparer.compare(type, value_type)
      end

      target
    end
  end
end
