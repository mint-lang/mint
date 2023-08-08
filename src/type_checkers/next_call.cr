module Mint
  class TypeChecker
    def check(node : Ast::NextCall) : Checkable
      entity = node.entity

      error! :next_call_invalid_invocation do
        block do
          text "A"
          bold "next call"
          text "can only called inside a component, store or provider but " \
               "you tried to call it here:"
        end

        snippet node
      end unless entity

      node.data.fields.each do |item|
        next unless key = item.key

        name =
          key.value

        state =
          case entity
          when Ast::Component, Ast::Store, Ast::Provider
            lookups[node] =
              {entity, nil}

            entity
              .states
              .find(&.name.value.==(name))
          end

        error! :next_call_state_not_found do
          snippet "I was looking for a state but could not find it:", name
          snippet "The next call in question is here:", node
        end unless state

        type =
          resolve item.value

        state_type =
          resolve state

        error! :next_call_state_type_mismatch do
          snippet "You were trying to assign an incompatible value " \
                  "to the state:", name
          snippet "The type of the state is:", state_type
          snippet "But the type you are trying to assign to it is:", type
          snippet "Here is where you did the assignment:", item
          snippet "And here is where the state is defined:", state
        end unless Comparer.compare(state_type, type)
      end

      Type.new("Promise", [VOID] of Checkable)
    end
  end
end
