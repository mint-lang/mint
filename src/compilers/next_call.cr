module Mint
  class Compiler
    def _compile(node : Ast::NextCall) : String
      entity =
        lookups[node]?

      state =
        node.data.fields.each_with_object({} of String => String) do |item, memo|
          field =
            case entity
            when Ast::Component, Ast::Store
              entity
                .states
                .find(&.name.value.==(item.key.value))
            end

          if field
            memo[js.variable_of(field)] = compile item.value
          else
            memo
          end
        end

      js.promise do
        js.arrow_function(["_resolve"]) do
          "this.setState(_u(this.state, new Record(#{js.object(state)})), _resolve)\n"
        end
      end
    end
  end
end
