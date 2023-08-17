module Mint
  class TypeChecker
    def check(node : Ast::NextCall) : Checkable
      entity = stateful?

      error :next_call_invalid_invocation do
        block do
          text "A"
          bold "next call"
          text "can only called inside a component or store."
        end

        snippet node
      end unless entity

      node.data.fields.each do |item|
        name =
          item.key.value

        state =
          case entity
          when Ast::Provider
            lookups[node] =
              entity

            entity
              .states
              .find(&.name.value.==(name))
          when Ast::Component, Ast::Store
            lookups[node] =
              entity

            entity
              .states
              .find(&.name.value.==(name))
          end

        error :next_call_state_not_found do
          block do
            text "I was looking for a state named"
            bold name
            text "but could not find it."
          end

          snippet node
        end unless state

        type =
          resolve item.value

        state_type =
          resolve state

        error :next_call_state_type_mismatch do
          block "You were trying to assign an incompatible value to the status state."
          snippet "The type of the state is:", state_type
          snippet "But the type you are trying to assign to it:", type
          snippet "Here is where you did the assignment:", item
          snippet "And here is where the state is defined:", state
        end unless Comparer.compare(state_type, type)
      end

      Type.new("Promise", [VOID] of Checkable)
    end
  end
end
