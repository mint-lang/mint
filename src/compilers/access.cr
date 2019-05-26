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

      if node.safe
        js.iif do
          js.statements([
            js.const("_", first),
            js.return(js.call("_s", ["_", "(_) => _.#{field}"])),
          ])
        end
      else
        "#{first}.#{field}"
      end
    end
  end
end
