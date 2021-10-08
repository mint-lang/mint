module Mint
  class TypeChecker
    type_error NextCallInvalidInvokation
    type_error NextCallStateTypeMismatch
    type_error NextCallStateNotFound

    def check(node : Ast::NextCall) : Checkable
      entity = stateful?

      raise NextCallInvalidInvokation, {
        "node" => node,
      } unless entity

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

        raise NextCallStateNotFound, {
          "name" => name,
          "node" => node,
        } unless state

        type =
          resolve item.value

        state_type =
          resolve state

        raise NextCallStateTypeMismatch, {
          "name"     => name,
          "expected" => state_type,
          "state"    => state,
          "node"     => item,
          "got"      => type,
        } unless Comparer.compare(state_type, type)
      end

      Type.new("Promise", [VOID] of Checkable)
    end
  end
end
