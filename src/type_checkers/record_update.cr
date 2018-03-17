class TypeChecker
  type_error RecordUpdateNotUpdatingRecord
  type_error RecordUpdateTypeMismatch
  type_error RecordUpdateNotFoundKey

  def check(node : Ast::RecordUpdate) : Type
    target =
      check node.variable

    raise RecordUpdateNotUpdatingRecord, {
      "target" => target,
      "node"   => node,
    } unless target.is_a?(Record)

    fields = node.fields.each do |field|
      type =
        check field.value

      value_type =
        target.fields[field.key.value]?

      raise RecordUpdateNotFoundKey, {
        "key"    => field.key.value,
        "target" => target,
        "node"   => field,
      } unless value_type

      raise RecordUpdateTypeMismatch, {
        "expected" => value_type,
        "node"     => field,
        "got"      => type,
      } unless Comparer.compare(type, value_type)
    end

    target
  end
end
