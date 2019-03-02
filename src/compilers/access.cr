module Mint
  class Compiler
    def _compile(node : Ast::Access) : String
      first =
        compile node.fields.first

      rest =
        node.fields[1..-1].map do |field|
          if record_name = record_field_lookup[field]?
            js.variable_of(record_name, field.value)
          else
            js.variable_of(lookups[field])
          end
        end

      ([first] + rest).join(".")
    end
  end
end
