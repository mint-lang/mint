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
          {
            node,
            node,
            js.call(Builtin::CreateProvider, [
              [node.subscription] of Item,
              if update
                compile_function(update, skip_const: true)
              else
                js.arrow_function { js.return(js.null) }
              end,
            ]),
          }

        subscriptions =
          {
            node,
            node.subscription,
            js.new("Map".as(Item)),
          }

        add functions + signals + states + gets + constants + [subscriptions, update]
      end
    end
  end
end
