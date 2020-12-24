module Mint
  class Compiler
    def _compile(node : Ast::Access) : Codegen::Node
      first =
        compile node.lhs

      field =
        if record_field_lookup[node.field]?
          node.field.value
        else
          js.variable_of(lookups[node.field])
        end

      if node.safe?
        js.iif do
          access =
            Codegen.symbol_mapped(node.lhs, node, Codegen.join ["_.", field])

          js.statements([
            js.const("_", first),
            js.return(js.call("_s", ["_", Codegen.join ["(_) => ", access]])),
          ])
        end
      else
        Codegen.symbol_mapped(node.lhs, node, Codegen.join [first, ".", field])
      end
    end
  end
end
