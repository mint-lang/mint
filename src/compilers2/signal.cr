module Mint
  class Compiler2
    def resolve(node : Ast::Signal)
      resolve node do
        block =
          compile node.block

        method =
          if (parent = node.parent).is_a?(Ast::Component) && !parent.global?
            Builtin::UseSignal
          else
            Builtin::Signal
          end

        {node, node, js.call(method, [block])}
      end
    end
  end
end
