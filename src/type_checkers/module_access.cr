module Mint
  class TypeChecker
    type_error ModuleAccessNotFoundFunction
    type_error ModuleAccessNotFoundModule

    def check(node : Ast::ModuleAccess) : Checkable
      entity =
        ast.modules.find(&.name.==(node.name)) ||
          ast.stores.find(&.name.==(node.name))

      item =
        case entity
        when Ast::Module
          entity.functions.find(&.name.value.==(node.variable.value))
        when Ast::Store
          entity.functions.find(&.name.value.==(node.variable.value)) ||
            entity.states.find(&.name.value.==(node.variable.value)) ||
            entity.gets.find(&.name.value.==(node.variable.value))
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

      lookups[node] = item

      check!(entity)

      resolve item
    end
  end
end
