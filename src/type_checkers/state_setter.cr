module Mint
  class TypeChecker
    def check(node : Ast::StateSetter) : Checkable
      entity =
        if name = node.entity.try(&.value)
          ast.components.find(&.name.==(name)) ||
            ast.providers.find(&.name.==(name)) ||
            ast.stores.find(&.name.==(name))
        end || node

      case item = scope.resolve(node.state.value, entity).try(&.node)
      when Ast::State
        type =
          resolve(item)

        lookups[node] = {item, nil}
        Type.new("Function", [type, VOID_PROMISE])
      else
        error! :state_setter_state_not_found do
          block do
            text "Could not find the state with the name:"
            bold node.state.value
          end

          snippet node
        end
      end
    end
  end
end
