class TypeChecker
  type_error UseSubscriptionMismatch
  type_error UseConditionMismatch
  type_error UseNotFoundProvider

  def check(node : Ast::Use) : Type
    condition =
      node.condition

    provider =
      ast.providers.find(&.name.==(node.provider))

    raise UseNotFoundProvider, {
      "name" => node.provider,
      "node" => node,
    } unless provider

    # This is checked by the provider so we assume it's there
    subscription =
      records.find(&.name.==(provider.subscription)).not_nil!

    record =
      check node.data

    raise UseSubscriptionMismatch, {
      "expected" => subscription,
      "got"      => record,
      "node"     => node,
    } unless Comparer.compare(record, subscription)

    if condition
      condition_type = check condition

      raise UseConditionMismatch, {
        "got"  => condition_type,
        "node" => condition,
      } unless Comparer.compare(condition_type, BOOL)
    end

    check node.data
  end
end
