module Mint
  class Compiler
    def _compile(node : Ast::RecordField) : String
      value =
        compile node.value

      name =
        js.variable_of(record_field_lookup[node], node.key.value)

      "#{name}: #{value}"
    end
  end
end
