module Mint
  class TypeChecker
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
          .branches[1..]
          .each_with_index
          .reduce(first) do |resolved, (branch, index)|
            type =
              resolve branch, condition

            unified_branch =
              Comparer.compare(type, resolved)

            error :case_branch_not_matches do
              block do
                text "The return type of the"
                bold "#{(index + 2)}. branch"
                text "of a case expression does not match the type of the first branch."
              end

              snippet "I was expecting:", resolved
              snippet "Instead it is:", type
              snippet branch
            end unless unified_branch

            unified_branch
          end

      catch_all =
        node.branches.find(&.match.nil?)

      case_unnecessary_all = ->(catch_node : Ast::Node) { error :case_unnecessary_all do
        block "All possibilities of the case expression are covered."
        snippet "This branch is not needed and can be safely removed.", catch_node
      end }

      case_not_covered = ->{ error :case_not_covered do
        block "Not all possibilities of a case expression are covered."
        block "To cover all remaining possibilities add an empty case branch:"

        code "=> return value"

        snippet node
      end }

      # At this point all branches have been checked the
      # type should be the same.
      case condition
      when Type
        parent =
          ast.enums.find(&.name.value.==(condition.name))

        if parent
          not_matched =
            parent.options.reject do |option|
              node
                .branches
                .any? do |branch|
                  case match = branch.match
                  when Ast::EnumDestructuring
                    match.option.value == option.value.value &&
                      !match.parameters.any? do |item|
                        item.is_a?(Ast::TupleDestructuring) ||
                          item.is_a?(Ast::EnumDestructuring) ||
                          item.is_a?(Ast::ArrayDestructuring)
                      end
                  else
                    false
                  end
                end
            end

          case_unnecessary_all.call(catch_all) if not_matched.empty? && catch_all

          options =
            not_matched.map do |option|
              "#{format parent.name}::#{formatter.replace_skipped(format(option.value))}"
            end.join('\n')

          error :case_enum_not_covered do
            block "Not all possibilities of a case expression are covered."
            block "To cover all remaining possibilities create branches for the following options:"

            snippet options
            snippet node
          end if !not_matched.empty? && !catch_all
        elsif condition.name == "Array"
          destructurings =
            node.branches
              .map(&.match)
              .select(Ast::ArrayDestructuring)
              .select! do |branch|
                branch.items.all? do |item|
                  item.is_a?(Ast::Variable) ||
                    item.is_a?(Ast::Spread)
                end
              end

          covers_cases =
            if destructurings.empty?
              true
            else
              (1..destructurings.max_of(&.items.size)).to_a.all? do |length|
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

          case_unnecessary_all.call(catch_all) if covered && catch_all
          case_not_covered.call if !covered && !catch_all
        elsif condition.name == "Tuple"
          destructured =
            node.branches.any? do |branch|
              case match = branch.match
              when Ast::TupleDestructuring
                match.exhaustive?
              else
                false
              end
            end

          case_unnecessary_all.call(catch_all) if destructured && catch_all
          case_not_covered.call if !destructured && !catch_all
        elsif !catch_all
          case_not_covered.call
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
