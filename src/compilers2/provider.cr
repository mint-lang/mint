module Mint
  class Compiler2
    def resolve(node : Ast::Provider)
      resolve node do
        update =
          node.functions.find!(&.name.value.==("update"))

        functions =
          (node.functions - [update]).map do |function|
            resolve function
          end

        states =
          resolve node.states

        gets =
          resolve node.gets

        constants =
          resolve node.constants

        update =
          {node, js.call(Builtin::CreateProvider, [[node.subscription] of Item, compile(update, skip_const: true)])}

        subscriptions =
          {node.subscription, js.call(Builtin::Signal, [js.array([[] of Item])])}

        add functions + states + gets + constants + [subscriptions, update]
      end
    end
  end
end
