module Mint
  class Compiler
    def compile(node : Ast::Variable) : Compiled
      compile node do
        if node.value == "void"
          ["null"] of Item
        else
          if item = variables[node]?
            entity, parent = item

            # Subscriptions for providers are handled here
            if node.value == "subscriptions" && parent.is_a?(Ast::Provider)
              return js.call(Builtin::Subscriptions, [[parent.subscription] of Item])
            end

            case {entity, parent}
            when {Ast::Component, Ast::Component},
                 {Ast::Component, Ast::Test},
                 {Ast::HtmlElement, Ast::Component},
                 {Ast::HtmlElement, Ast::Test}
              case parent
              when Ast::Component, Ast::Test
                ref =
                  parent
                    .refs
                    .find! { |(ref, _)| ref.value == node.value }[0]

                [Signal.new(ref)] of Item
              else
                raise "SHOULD NOT HAPPEN"
              end
            else
              case entity
              when Ast::Get
                js.call(entity, [] of Compiled)
              when Ast::State, Ast::Signal
                [Signal.new(entity)] of Item
              when Ast::Constant
                if (parent = entity.parent).is_a?(Ast::Component) && !parent.global?
                  [Signal.new(entity)] of Item
                else
                  [entity] of Item
                end
              else
                [entity] of Item
              end
            end
          elsif type = cache[node]?
            if type.name == "Function"
              js.call(Builtin::NewVariant, [
                tag(node, type.parameters.last),
              ] of Compiled)
            else
              js.call(Builtin::NewVariant, [
                tag(node, type),
              ] of Compiled)
            end
          end || [] of Item
        end
      end
    end
  end
end
