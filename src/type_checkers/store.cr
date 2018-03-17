class TypeChecker
  type_error StoreEntityNameConflict

  def check(node : Ast::Store) : Type
    check_names node.functions, StoreEntityNameConflict
    check_global_names node.name, node

    scope node do
      check node.properties, node
      check node.functions
    end

    NEVER
  end
end
