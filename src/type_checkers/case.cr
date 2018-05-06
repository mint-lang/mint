module Mint
  class TypeChecker
    type_error CaseBranchNotMatches

    def check(node : Ast::Case) : Type
      condition =
        check node.condition

      first =
        check node.branches.first, condition

      node.branches[1..node.branches.size].each_with_index do |branch, index|
        type = check branch, condition

        raise CaseBranchNotMatches, {
          "index"    => (index + 1).to_s,
          "expected" => first,
          "got"      => type,
          "node"     => branch,
        } unless Comparer.compare(type, first)
      end

      first
    end
  end
end
