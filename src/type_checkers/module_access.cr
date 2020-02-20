module Mint
  class TypeChecker
    type_error ModuleAccessNotFoundFunction
    type_error ModuleAccessNotFoundModule

    def check(node : Ast::ModuleAccess) : Checkable
      entity =
        ast.modules.find(&.name.==(node.name)) ||
          ast.stores.find(&.name.==(node.name)) ||
          ast.providers.find(&.name.==(node.name)) ||
          ast.components
            .select(&.global)
            .find(&.name.==(node.name))

      item =
        case entity
        when Ast::Provider
          if node.variable.value == "subscriptions"
            subscription =
              scope entity do
                lookup(node.variable)
              end

            case subscription
            when Type
              check!(entity)
              lookups[node] = entity
              return subscription
            else
              # Should not happen
              raise TypeError
            end
          else
            entity.functions.find(&.name.value.==(node.variable.value))
          end
        when Ast::Module
          entity.functions.find(&.name.value.==(node.variable.value)) ||
            entity.constants.find(&.name.==(node.variable.value))
        when Ast::Component
          entity.properties.find(&.name.value.==(node.variable.value)) ||
            entity.functions.find(&.name.value.==(node.variable.value)) ||
            entity.states.find(&.name.value.==(node.variable.value)) ||
            entity.constants.find(&.name.==(node.variable.value)) ||
            entity.gets.find(&.name.value.==(node.variable.value))
        when Ast::Store
          entity.functions.find(&.name.value.==(node.variable.value)) ||
            entity.states.find(&.name.value.==(node.variable.value)) ||
            entity.gets.find(&.name.value.==(node.variable.value)) ||
            entity.constants.find(&.name.==(node.variable.value))
        else
          raise ModuleAccessNotFoundModule, {
            "name" => node.name,
            "node" => node,
          }
        end

      raise ModuleAccessNotFoundFunction, {
        "name"   => node.variable.value,
        "entity" => node.name,
        "node"   => node,
      } unless item

      lookups[node] = entity
      lookups[node.variable] = item

      check!(entity)

      scope entity do
        resolve item
      end
    end
  end
end
