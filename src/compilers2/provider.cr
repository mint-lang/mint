module Mint
  class Compiler2
    def resolve(node : Ast::Provider)
      resolve node do
        update =
          node.functions.find!(&.name.value.==("update"))

        functions =
          resolve(node.functions - [update])

        constants =
          resolve node.constants

        states =
          resolve node.states

        gets =
          resolve node.gets

        update =
          {
            node,
            node,
            js.call(Builtin::CreateProvider, [
              [node.subscription] of Item,
              compile(update, skip_const: true),
            ]),
          }

        subscriptions =
          {
            node.subscription,
            node.subscription,
            js.new("Map".as(Item)),
          }

        add functions + states + gets + constants + [subscriptions, update]
      end
    end
  end
end
