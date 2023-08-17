module Mint
  class TypeChecker
    def check(node : Ast::ModuleAccess) : Checkable
      name =
        node.name

      entity =
        ast.unified_modules.find(&.name.value.==(name.value)) ||
          ast.stores.find(&.name.value.==(name.value)) ||
          ast.providers.find(&.name.value.==(name.value)) ||
          ast.components
            .select(&.global?)
            .find(&.name.value.==(name.value))

      variable_value =
        node.variable.value

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
            entity.functions.find(&.name.value.==(variable_value))
          end
        when Ast::Module
          entity.functions.find(&.name.value.==(variable_value)) ||
            entity.constants.find(&.name.value.==(variable_value))
        when Ast::Component
          entity.properties.find(&.name.value.==(variable_value)) ||
            entity.functions.find(&.name.value.==(variable_value)) ||
            entity.states.find(&.name.value.==(variable_value)) ||
            entity.constants.find(&.name.value.==(variable_value)) ||
            entity.gets.find(&.name.value.==(variable_value))
        when Ast::Store
          entity.functions.find(&.name.value.==(variable_value)) ||
            entity.states.find(&.name.value.==(variable_value)) ||
            entity.gets.find(&.name.value.==(variable_value)) ||
            entity.constants.find(&.name.value.==(variable_value))
        else
          error :module_access_not_found_module do
            block do
              text "I cannot find a module or store with the name"
              bold name.value
            end

            snippet node
          end
        end

      error :module_access_not_found_function do
        block do
          text "The entity"
          bold variable_value
          text "you tried to reference does not exists in the module or store"
          bold name.value
        end

        snippet node
      end unless item

      lookups[node] = entity
      lookups[node.variable] = item

      check!(entity)

      scope entity do
        resolve item
      end
    end
  end
end
