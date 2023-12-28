module Mint
  class Compiler2
    def resolve(node : Ast::State)
      resolve node do
        default =
          compile node.default

        method =
          case node.parent
          when Ast::Component
            Builtin::UseSignal
          else
            Builtin::Signal
          end

        {node, js.call(method, [default])}
      end
    end
  end
end
