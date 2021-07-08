module Mint
  class TypeChecker
    type_error RecordConstructorArgumentSizeMismatch
    type_error RecordConstructorArgumentTypeMismatch
    type_error RecordConstructorNotFoundRecord

    def check(node : Ast::EnumId, record : Record) : Checkable
      fields =
        record.fields.values

      raise RecordConstructorArgumentSizeMismatch, {
        "argument_size" => node.expressions.size.to_s,
        "size"          => fields.size.to_s,
        "record"        => record,
        "node"          => node,
      } if node.expressions.size > fields.size

      node.expressions.each_with_index do |argument, index|
        type = resolve argument

        raise RecordConstructorArgumentTypeMismatch, {
          "expected" => fields[index],
          "node"     => argument,
          "got"      => type,
        } unless Comparer.compare(type, fields[index])
      end

      types[node] = record

      if record.fields.size == node.expressions.size
        record
      else
        Type.new("Function", fields.skip(node.expressions.size) + [record])
      end
    end
  end
end
