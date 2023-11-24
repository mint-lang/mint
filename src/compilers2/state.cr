module Mint
  class Compiler2
    def compile(node : Ast::State) : Compiled
      compile node do
        default =
          compile node.default

        method =
          case node.parent
          when Ast::Component
            Builtin::UseSignal
          else
            Builtin::Signal
          end

        js.const(node, js.call(method, [default]))
      end
    end
  end
end
