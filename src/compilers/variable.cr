module Mint
  class Compiler
    def compile(node : Ast::Variable) : Compiled
      compile node do
        if node.value == "void"
          ["null"] of Item
        else
          entity, parent =
            variables[node]

          # Subscriptions for providers are handled here
          if node.value == "subscriptions" && parent.is_a?(Ast::Provider)
            return js.call(Builtin::Subscriptions, [[parent.subscription] of Item])
          end

          case {entity, parent}
          when {Ast::Component, Ast::Component},
               {Ast::HtmlElement, Ast::Component}
            case parent
            when Ast::Component
              ref =
                parent
                  .refs
                  .find! { |(ref, _)| ref.value == node.value }[0]

              [Ref.new(ref)] of Item
            else
              raise "SHOULD NOT HAPPEN"
            end
          else
            case entity
            when Ast::Get
              js.call(entity, [] of Compiled)
            when Ast::State, Ast::Signal
              [Signal.new(entity)] of Item
            else
              [entity] of Item
            end
          end
        end
      end
    end
  end
end
