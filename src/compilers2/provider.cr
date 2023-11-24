module Mint
  class Compiler2
    def compile(node : Ast::Provider) : Compiled
      compile node do
        update =
          node.functions.find!(&.name.value.==("update"))

        functions =
          (node.functions - [update]).map do |function|
            compile function
          end

        states =
          compile node.states

        gets =
          compile node.gets

        constants =
          compile node.constants

        update =
          js.const(node, js.call(Builtin::CreateProvider, [[node.subscription] of Item, compile(update)]))

        subscriptions =
          js.const(node.subscription, js.call(Builtin::Signal, [js.array([[] of Item])]))

        @compiled << js.statements(functions + states + gets + constants + [subscriptions, update])

        [] of Item
      end
    end
  end
end
