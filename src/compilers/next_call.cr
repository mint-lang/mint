module Mint
  class Compiler
    def compile(node : Ast::NextCall) : Compiled
      compile node do
        if node.data.fields.empty?
          js.null
        else
          assigns =
            node.data.fields.compact_map do |item|
              next unless field = lookups[item]?.try(&.first?)
              js.assign(Signal.new(field), compile(item.value))
            end

          if assigns.size > 1
            js.call(Builtin::Batch, [
              js.arrow_function { js.statements(assigns) },
            ])
          else
            js.iif { assigns[0] }
          end
        end
      end
    end
  end
end
