module Mint
  class Compiler
    def resolve(node : Ast::Provider)
      resolve node do
        update =
          node.functions.find(&.name.value.==("update"))

        functions =
          resolve(node.functions - [update])

        constants =
          resolve node.constants

        signals =
          resolve node.signals

        states =
          resolve node.states

        gets =
          resolve node.gets

        update =
          if update
            {
              node,
              node,
              js.call(Builtin::CreateProvider, [
                [node.subscription] of Item,
                compile_function(update, skip_const: true),
              ]),
            }
          end

        subscriptions =
          {
            node,
            node.subscription,
            js.new("Map".as(Item)),
          }

        add functions + signals + states + gets + constants + [subscriptions, update].compact
      end
    end
  end
end
