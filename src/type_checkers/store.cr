module Mint
  class TypeChecker
    type_error StoreEntityNameConflict

    def check(node : Ast::Store) : Checkable
      # Checking for global naming conflict
      check_global_names node.name, node

      # Checking for naming conflicts
      checked =
        {} of String => Ast::Node

      check_names(node.functions, StoreEntityNameConflict, checked)
      check_names(node.states, StoreEntityNameConflict, checked)
      check_names(node.gets, StoreEntityNameConflict, checked)

      # Type checking the entities
      scope node do
        resolve node.constants
        resolve node.functions
        resolve node.states
        resolve node.gets
      end

      NEVER
    end
  end
end
