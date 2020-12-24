module Mint
  class Compiler
    def _compile(node : Ast::NextCall) : Codegen::Node
      entity =
        lookups[node]?

      state =
        node.data.fields.each_with_object({} of Codegen::Node => Codegen::Node) do |item, memo|
          field =
            case entity
            when Ast::Provider
              entity
                .states
                .find(&.name.value.==(item.key.value))
            when Ast::Component, Ast::Store
              entity
                .states
                .find(&.name.value.==(item.key.value))
            end

          if field
            memo[js.variable_of(field)] =
              Codegen.source_mapped(item.value, compile item.value)
          else
            memo
          end
        end

      js.promise do
        js.arrow_function(["_resolve"]) do
          Codegen.join [
            "this.setState(_u(this.state, new Record(", js.object(state), ")), _resolve)",
          ]
        end
      end
    end
  end
end
