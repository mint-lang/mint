class TypeChecker
  type_error StateNotFoundRecord
  type_error StateRecordMismatch

  def check(node : Ast::State) : Type
    record =
      check node.type

    type =
      check node.data

    raise StateRecordMismatch, {
      "expected" => record,
      "node"     => node.data,
      "got"      => type,
    } unless Comparer.compare(record, type)

    type
  rescue RecordNotFoundMatchingRecord
    raise StateNotFoundRecord, {
      "record" => node.type.name,
      "node"   => node.type,
    }
  end
end
