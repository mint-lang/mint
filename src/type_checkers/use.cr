module Mint
  class TypeChecker
    def check(node : Ast::Use) : Checkable
      condition =
        node.condition

      provider =
        ast.providers.find(&.name.value.==(node.provider.value))

      error :use_not_found_provider do
        block do
          text "I could not find the provider with the name:"
          bold node.provider.value
        end

        snippet node
      end unless provider

      resolve provider

      lookups[node] = provider

      # This is checked by the provider so we assume it's there
      subscription =
        records.find!(&.name.==(provider.subscription.value))

      record =
        resolve node.data

      error :use_subscription_mismatch do
        block "The subsctipion of a provider does not match its definition."
        expected subscription, record
        snippet node
      end unless Comparer.compare(record, subscription)

      if condition
        condition_type = resolve condition

        error :use_condition_mismatch do
          block do
            text "The expression of the"
            bold "where condition"
            text "must evaluate to a boolean value."
          end

          expected BOOL, condition_type

          snippet condition
        end unless Comparer.compare(condition_type, BOOL)
      end

      resolve node.data
    end
  end
end
