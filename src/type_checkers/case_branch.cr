module Mint
  class TypeChecker
    type_error CaseBranchNotMatchCondition

    def check(node : Ast::CaseBranch, condition : Checkable) : Checkable
      node.match.try do |item|
        case item
        when Ast::EnumOption
          # TODO Descrtucture here
        else
          match = resolve item

          raise CaseBranchNotMatchCondition, {
            "expected" => condition,
            "got"      => match,
            "node"     => item,
          } unless Comparer.compare(match, condition)
        end
      end || resolve node.expression
    end
  end
end
