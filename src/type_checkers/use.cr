module Mint
  class TypeChecker
    type_error UseSubscriptionMismatch
    type_error UseConditionMismatch
    type_error UseNotFoundProvider

    def check(node : Ast::Use) : Checkable
      condition =
        node.condition

      provider =
        ast.providers.find(&.name.==(node.provider))

      raise UseNotFoundProvider, {
        "name" => node.provider,
        "node" => node,
      } unless provider

      resolve provider

      lookups[node] = provider

      # This is checked by the provider so we assume it's there
      subscription =
        records.find(&.name.==(provider.subscription)).not_nil!

      record =
        resolve node.data

      raise UseSubscriptionMismatch, {
        "expected" => subscription,
        "got"      => record,
        "node"     => node,
      } unless Comparer.compare(record, subscription)

      if condition
        condition_type = resolve condition

        raise UseConditionMismatch, {
          "got"  => condition_type,
          "node" => condition,
        } unless Comparer.compare(condition_type, BOOL)
      end

      resolve node.data
    end
  end
end
