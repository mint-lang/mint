module Mint
  class TypeChecker
    type_error CaseBranchNotMatches
    type_error CaseUnnecessaryAll
    type_error CaseEnumNotCovered
    type_error CaseNotCovered

    def check(node : Ast::Case) : Checkable
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

      catch_all =
        node.branches.find(&.match.nil?)

      # At this point all branches have been checked the
      # type should be the same.
      case condition
      when Type
        item =
          ast.enums.find(&.name.==(condition.name))

        if item
          not_matched =
            item.options.reject do |option|
              node
                .branches
                .map(&.match)
                .compact
                .any? do |match|
                  case match
                  when Ast::EnumDestructuring
                    match.option == option.value
                  else
                    false
                  end
                end
            end

          raise CaseUnnecessaryAll, {
            "node" => catch_all,
          } if not_matched.empty? && catch_all

          options =
            not_matched.map do |option|
              "#{item.name}::#{formatter.replace_skipped(format(option))}"
            end

          raise CaseEnumNotCovered, {
            "options" => options,
            "node"    => node,
          } if not_matched.any? && !catch_all
        elsif !catch_all
          raise CaseNotCovered, {
            "node" => node,
          }
        end
      end

      first
    end
  end
end
