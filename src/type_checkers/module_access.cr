class TypeChecker
  type_error ModuleAccessNotFoundFunction
  type_error ModuleAccessNotFoundModule

  def check(node : Ast::ModuleAccess) : Type
    entity =
      ast.modules.find(&.name.==(node.name)) ||
        ast.stores.find(&.name.==(node.name))

    item =
      case entity
      when Ast::Module
        entity.functions.find(&.name.value.==(node.variable.value))
      when Ast::Store
        entity.functions.find(&.name.value.==(node.variable.value)) ||
          entity.properties.find(&.name.value.==(node.variable.value))
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

    check item
  end
end
