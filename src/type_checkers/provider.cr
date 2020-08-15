module Mint
  class TypeChecker
    type_error ProviderNotFoundSubscription
    type_error ProviderEntityNameConflict

    def check(node : Ast::Provider) : Checkable
      # Checking for global naming conflict
      check_global_names node.name, node

      # Checking for naming conflicts
      checked =
        {} of String => Ast::Node

      check_names node.functions, ProviderEntityNameConflict, checked
      check_names node.states, ProviderEntityNameConflict, checked
      check_names node.gets, ProviderEntityNameConflict, checked

      # Checking for subscription
      subscription =
        records.find(&.name.==(node.subscription))

      raise ProviderNotFoundSubscription, {
        "name" => node.subscription,
        "node" => node,
      } unless subscription

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
