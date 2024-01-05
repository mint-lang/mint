module Mint
  class Compiler2
    def resolve(node : Ast::Get)
      resolve node do
        body =
          compile node.body, for_function: true

        method =
          if (parent = node.parent).is_a?(Ast::Component) && !parent.global?
            Builtin::UseComputed
          else
            Builtin::Computed
          end

        {node, node, js.call(method, [js.arrow_function { body }])}
      end
    end
  end
end
