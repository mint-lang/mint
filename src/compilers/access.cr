module Mint
  class Compiler
    def _compile(node : Ast::Access) : String
      first =
        compile node.lhs

      field =
        if record_field_lookup[node.field]?
          node.field.value
        else
          js.variable_of(lookups[node.field])
        end

      "#{first}.#{field}"
    end
  end
end
