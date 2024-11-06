module Mint
  class Compiler
    def resolve(node : Ast::Constant)
      resolve node do
        value =
          compile(node.expression)

        item =
          if (parent = node.parent).is_a?(Ast::Component) && !parent.global?
            js.call(Builtin::UseSignal, [value])
          else
            value
          end

        {node, node, item}
      end
    end
  end
end
