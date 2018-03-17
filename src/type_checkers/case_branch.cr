class TypeChecker
  type_error CaseBranchNotMatchCondition

  def check(node : Ast::CaseBranch, condition : Type) : Type
    if node.match
      match =
        check node.match.not_nil!

      raise CaseBranchNotMatchCondition, {
        "expected" => condition,
        "got"      => match,
        "node"     => node,
      } unless Comparer.compare(match, condition)
    end

    check node.expression
  end
end
