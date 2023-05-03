module Mint
  class TypeChecker
    type_error CaseBranchNotMatches
    type_error CaseUnnecessaryAll
    type_error CaseEnumNotCovered
    type_error CaseNotCovered

    def check(node : Ast::Case) : Checkable
      condition =
        resolve node.condition

      await = false

      case condition
      when Type
        if condition.name == "Promise" && node.await
          condition = condition.parameters.first
          await = true
        end
      end

      first =
        resolve node.branches.first, condition

      unified =
        node
          .branches[1..node.branches.size]
          .each_with_index
          .reduce(first) do |resolved, (branch, index)|
            type =
              resolve branch, condition

            unified_branch =
              Comparer.compare(type, resolved)

            raise CaseBranchNotMatches, {
              "index"    => (index + 1).to_s,
              "expected" => resolved,
              "got"      => type,
              "node"     => branch,
            } unless unified_branch

            unified_branch
          end

      catch_all =
        node.branches.find(&.match.nil?)

      # At this point all branches have been checked the
      # type should be the same.
      case condition
      when Type
        item =
          ast.enums.find(&.name.value.==(condition.name))

        if item
          not_matched =
            item.options.reject do |option|
              node
                .branches
                .compact_map(&.match)
                .any? do |match|
                  case match
                  when Ast::EnumDestructuring
                    match.option.value == option.value.value
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
              "#{format item.name}::#{formatter.replace_skipped(format(option))}"
            end

          raise CaseEnumNotCovered, {
            "options" => options,
            "node"    => node,
          } if !not_matched.empty? && !catch_all
        elsif condition.name == "Array"
          destructurings =
            node.branches.map(&.match).select(Ast::ArrayDestructuring)

          covers_cases =
            if destructurings.empty?
              true
            else
              (1..destructurings.map(&.items.size).max).to_a.all? do |length|
                destructurings.any?(&.covers?(length))
              end
            end

          covers_empty =
            node.branches
              .map(&.match)
              .select(Ast::ArrayLiteral)
              .any?(&.items.empty?)

          covers_infitiy =
            destructurings.any?(&.spread?)

          covered =
            covers_cases && covers_infitiy && covers_empty

          raise CaseUnnecessaryAll, {
            "node" => catch_all,
          } if covered && catch_all

          raise CaseNotCovered, {
            "node" => node,
          } if !covered && !catch_all
        elsif condition.name == "Tuple"
          destructured =
            node.branches.map(&.match).any? do |match|
              case match
              when Ast::TupleDestructuring
                match.parameters.all?(Ast::Variable)
              else
                false
              end
            end

          raise CaseUnnecessaryAll, {
            "node" => catch_all,
          } if destructured && catch_all

          raise CaseNotCovered, {
            "node" => node,
          } if !destructured && !catch_all
        elsif !catch_all
          raise CaseNotCovered, {
            "node" => node,
          }
        end
      end

      if await && unified.name != "Promise"
        Type.new("Promise", [unified] of Checkable)
      else
        unified
      end
    end
  end
end
