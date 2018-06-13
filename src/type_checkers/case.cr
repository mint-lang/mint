module Mint
  class TypeChecker
    type_error CaseBranchNotMatches

    def check(node : Ast::Case) : Type
      condition =
        resolve node.condition

      first =
        resolve node.branches.first, condition

      node.branches[1..node.branches.size].each_with_index do |branch, index|
        type = resolve branch, condition

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
