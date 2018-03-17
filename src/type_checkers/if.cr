class TypeChecker
  type_error IfConditionTypeMismatch
  type_error IfElseTypeMismatch

  def check(node : Ast::If) : Type
    condition =
      check node.condition

    truthy =
      check node.truthy

    falsy =
      check node.falsy

    raise IfConditionTypeMismatch, {
      "node" => node.condition,
      "got"  => condition,
    } unless Comparer.compare(condition, BOOL)

    raise IfElseTypeMismatch, {
      "expected" => truthy,
      "got"      => falsy,
      "node"     => node,
    } unless Comparer.compare(truthy, falsy)

    truthy
  end
end
