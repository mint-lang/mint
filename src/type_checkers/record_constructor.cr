module Mint
  class TypeChecker
    type_error RecordConstructorArgumentSizeMismatch
    type_error RecordConstructorArgumentTypeMismatch
    type_error RecordConstructorNotFoundRecord

    def check(node : Ast::RecordConstructor) : Checkable
      record =
        records.find(&.name.==(node.name))

      raise RecordConstructorNotFoundRecord, {
        "name" => node.name,
        "node" => node,
      } unless record

      fields =
        record.fields.values

      raise RecordConstructorArgumentSizeMismatch, {
        "argument_size" => node.arguments.size.to_s,
        "size"          => fields.size.to_s,
        "record"        => record,
        "node"          => node,
      } if node.arguments.size > fields.size

      node.arguments.each_with_index do |argument, index|
        type = resolve argument

        raise RecordConstructorArgumentTypeMismatch, {
          "expected" => fields[index],
          "node"     => argument,
          "got"      => type,
        } unless Comparer.compare(type, fields[index])
      end

      types[node] = record

      if record.fields.size == node.arguments.size
        record
      else
        Type.new("Function", fields.skip(node.arguments.size))
      end
    end
  end
end
