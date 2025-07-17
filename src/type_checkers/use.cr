module Mint
  class TypeChecker
    def check(node : Ast::Use) : Checkable
      condition =
        node.condition

      provider =
        ast.providers.find(&.name.value.==(node.provider.value)) ||
          ast.type_definitions.find(&.name.value.==(node.provider.value))

      error! :use_not_found_provider do
        snippet "I could not find a provider:", node.provider
      end unless provider

      resolve provider

      lookups[node] = {provider, nil}

      case provider
      when Ast::TypeDefinition
        record =
          resolve node.data

        type =
          resolve provider

        error! :provider_type_mismatch do
          block "The type of a provider does not match its definition."
          expected type, record
          snippet "The provider in question is here:", node
        end unless Comparer.compare(record, type)

        record
      when Ast::Provider
        # This is checked by the provider so we assume it's there
        subscription =
          records.find!(&.name.==(provider.subscription.value))

        record =
          resolve node.data

        error! :use_subscription_mismatch do
          block "The subsctipion of a provider does not match its definition."
          expected subscription, record
          snippet "The provider in question is here:", node
        end unless Comparer.compare(record, subscription)

        if condition
          condition_type = resolve condition

          error! :use_condition_mismatch do
            block do
              text "The expression of the"
              bold "where condition"
              text "must evaluate to a boolean value. Instead it is:"
            end

            snippet condition_type
            snippet "The condition in question is here:", condition
          end unless Comparer.compare(condition_type, BOOL)
        end

        record
      else
        unreachable! "Use invalid provider / context type: #{provider.class.name}"
      end
    end
  end
end
