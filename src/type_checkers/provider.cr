module Mint
  class TypeChecker
    type_error ProviderNotFoundSubscription
    type_error ProviderEntityNameConflict

    def check(node : Ast::Provider) : Checkable
      check_names node.functions, ProviderEntityNameConflict
      check_global_names node.name, node

      subscription =
        records.find(&.name.==(node.subscription))

      raise ProviderNotFoundSubscription, {
        "name" => node.subscription,
        "node" => node,
      } unless subscription

      scope node do
        resolve node.functions
      end

      NEVER
    end
  end
end
