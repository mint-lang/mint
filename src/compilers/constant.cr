module Mint
  class Compiler
    def resolve(node : Ast::Constant)
      resolve node do
        compiled =
          compile(node.expression)

        item =
          if (parent = node.parent).is_a?(Ast::Component) && !parent.global?
            if names = artifacts.dependencies[node]?
              # A constant which depends on values the component gets is
              # computed again when they change.
              js.call(Builtin::UseMemo, [
                js.arrow_function { js.return(js.call(Builtin::Signal, [compiled])) },
                js.array(names.map { |name| value(name) }),
              ])
            else
              js.call(Builtin::UseSignal, [compiled])
            end
          else
            compiled
          end

        {node, node, item}
      end
    end
  end
end
