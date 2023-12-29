module Mint
  class Compiler2
    def resolve(node : Ast::State)
      resolve node do
        default =
          compile node.default

        method =
          if (parent = node.parent).is_a?(Ast::Component) && !parent.global?
            Builtin::UseSignal
          else
            Builtin::Signal
          end

        {node, js.call(method, [default])}
      end
    end
  end
end
