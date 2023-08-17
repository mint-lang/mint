module Mint
  class TypeChecker
    def check(node : Ast::EnumId, record : Record) : Checkable
      fields =
        record.fields.values

      error :record_constructor_argument_size_mismatch do
        block do
          text "The record you tried to create has"
          bold fields.size.to_s
          text "fields, while you tried to create it with"
          bold node.expressions.size.to_s
        end

        snippet record
        snippet "You tried to create it here:", node
      end if node.expressions.size > fields.size

      node.expressions.each_with_index do |argument, index|
        type = resolve argument

        error :record_constructor_argument_type_mismatch do
          block do
            text "The supplied values type does not match the type"
            text "of the field."
          end

          snippet "The type of the field is:", fields[index]
          snippet "You tried to supply it with:", type

          snippet argument
        end unless Comparer.compare(type, fields[index])
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
