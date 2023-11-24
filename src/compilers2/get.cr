module Mint
  class Compiler2
    def compile(node : Ast::Get) : Compiled
      compile node do
        body =
          compile node.body, for_function: true

        js.const(node, js.call(Builtin::Computed, [js.arrow_function { body }]))
      end
    end
  end
end
