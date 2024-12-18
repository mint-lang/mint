module Mint
  class TypeChecker
    def check(node : Ast::NextCall) : Checkable
      node.data.fields.each do |item|
        next unless key = item.key

        name =
          key.value

        state =
          case parent = node.entity
          when Ast::Component, Ast::Store, Ast::Provider
            parent
              .states
              .find(&.name.value.==(name))
          end

        state ||=
          begin
            error! :next_call_state_not_found do
              snippet "I was looking for a state but could not find it:", name
              snippet "The next call in question is here:", node
            end unless found = lookup_with_level(key)

            found[0]
          end

        valid =
          case state
          when Ast::State
            true
          when Ast::Variable
            (parent = state.parent) &&
              parent.is_a?(Ast::Statement) &&
              parent.target == state &&
              parent.signal?
          end

        error! :next_call_invalid do
          block do
            text "A"
            bold "next call"
            text "can only be used to set states and signals."
          end

          snippet node
          snippet "You tried to set the value of this:", state
        end unless valid

        lookups[item] =
          {state, nil}

        type =
          resolve item.value

        state_type =
          resolve(state).try do |stype|
            case state
            when Ast::Variable
              if stype.name == "Signal"
                stype.parameters.first
              end
            end || stype
          end

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
