module Mint
  class TypeChecker
    def check(node : Ast::Provider) : Checkable
      # Checking for global naming conflict
      check_global_names node.name.value, node

      # Checking for naming conflicts
      checked =
        {} of String => Ast::Node

      check_names node.functions, "provider", checked
      check_names node.states, "provider", checked
      check_names node.gets, "provider", checked

      error! :provider_not_found_subscription do
        block do
          text "I was looking for the type of the subscription"
          bold %("#{node.subscription.value}")
          text "but could not find it:"
        end

        snippet node
      end unless ast.type_definitions.find(&.name.value.==(node.subscription.value))

      # Type checking the entities
      resolve node.constants
      resolve node.functions
      resolve node.states
      resolve node.gets

      VOID
    end
  end
end
