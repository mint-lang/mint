module Mint
  class TypeChecker
    type_error CaseBranchNotMatchCondition

    def check(node : Ast::CaseBranch, condition : Type, name : String | Nil) : Type
      type =
        node.match.try do |item|
          match = resolve item

          raise CaseBranchNotMatchCondition, {
            "expected" => condition,
            "got"      => match,
            "node"     => item,
          } unless Comparer.compare(match, condition)

          match
        end

      if name && type
        scope({name, type}) do
          resolve node.expression
        end
      else
        resolve node.expression
      end
    end
  end
end
