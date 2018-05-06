module Mint
  class TypeChecker
    type_error CaseBranchNotMatchCondition

    def check(node : Ast::CaseBranch, condition : Type) : Type
      node.match.try do |item|
        match = check item

        raise CaseBranchNotMatchCondition, {
          "expected" => condition,
          "got"      => match,
          "node"     => item,
        } unless Comparer.compare(match, condition)
      end

      check node.expression
    end
  end
end
