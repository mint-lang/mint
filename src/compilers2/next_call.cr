module Mint
  class Compiler2
    def compile(node : Ast::NextCall) : Compiled
      entity =
        lookups[node]?.try(&.first?)

      if node.data.fields.empty?
        ["null"] of Item
      else
        assigns =
          node.data.fields.compact_map do |item|
            next unless key = item.key

            field =
              case entity
              when Ast::Provider
                entity
                  .states
                  .find(&.name.value.==(key.value))
              when Ast::Component, Ast::Store
                entity
                  .states
                  .find(&.name.value.==(key.value))
              end

            next unless field

            js.assign(Signal.new(field), compile(item.value))
          end

        if assigns.size > 1
          js.call(Builtin::Batch, [js.arrow_function {
            js.statements(assigns)
          }])
        else
          js.iif { assigns[0] }
        end
      end
    end
  end
end
