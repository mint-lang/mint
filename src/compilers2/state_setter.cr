module Mint
  class Compiler2
    def compile(node : Ast::StateSetter) : Compiled
      compile node do
        variable =
          Variable.new

        js.arrow_function([[variable] of Item]) do
          js.assign(Signal.new(lookups[node].first), [variable] of Item)
        end
      end
    end
  end
end
