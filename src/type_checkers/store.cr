module Mint
  class TypeChecker
    type_error StoreEntityNameConflict

    def check(node : Ast::Store) : Type
      # Checking for global naming conflict
      check_global_names node.name, node

      # Checking for naming conflicts
      checked =
        {} of String => Ast::Node

      check_names(node.properties, StoreEntityNameConflict, checked)
      check_names(node.functions, StoreEntityNameConflict, checked)

      # Type checking the entities
      scope node do
        check node.properties, node
        check node.functions
      end

      NEVER
    end
  end
end
