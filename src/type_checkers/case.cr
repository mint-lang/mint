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

            error! :case_branch_not_matches do
              block do
                text "The return type of the"
                bold "#{ordinal(index + 2)} branch"
                text "of a case expression does not match the type of the 1st branch."
              end

              snippet "I was expecting the type of the 1st branch:", resolved
              snippet "Instead it is:", type
              snippet "The branch in question is here:", branch
            end unless unified_branch

            unified_branch
          end

      catch_all =
        node.branches.find(&.pattern.nil?)

      case_unnecessary_all =
        ->(catch_node : Ast::Node) { error! :case_unnecessary_all do
          snippet "All possibilities of the case expression are covered so " \
                  "this branch is not needed and can be safely removed.", catch_node
        end }

      case_not_covered = ->{ error! :case_not_covered do
        snippet(
          "Not all possibilities of a case expression are covered. To " \
          "cover all remaining possibilities add an empty case branch:",
          "=> returnValue")

        snippet "The case in question is here:", node
      end }

      # At this point all branches have been checked the
      # type should be the same.
      case condition
      when Type
        parent =
          ast.type_definitions.find(&.name.value.==(condition.name))

        if parent
          not_matched =
            case fields = parent.fields
            when Array(Ast::TypeVariant)
              fields.reject do |field|
                node
                  .branches
                  .any? do |branch|
                    case pattern = branch.pattern
                    when Ast::TypeDestructuring
                      pattern.variant.value == field.value.value &&
                        !pattern.items.any? do |item|
                          item.is_a?(Ast::TupleDestructuring) ||
                            item.is_a?(Ast::TypeDestructuring) ||
                            item.is_a?(Ast::ArrayDestructuring)
                        end
                    else
                      false
                    end
                  end
              end
            else
              [] of Ast::TypeVariant
            end

          case_unnecessary_all.call(catch_all) if not_matched.empty? && catch_all

          cases =
            not_matched.map do |variant|
              "#{format parent.name}.#{formatter.replace_skipped(format(variant.value))}"
            end.join('\n')

          error! :case_type_not_covered do
            snippet "Not all possibilities of a case expression are covered. " \
                    "To cover all remaining possibilities create branches " \
                    "for the following cases:", cases

            snippet "The case in question is here:", node
          end if !not_matched.empty? && !catch_all
        elsif condition.name == "Array"
          destructurings =
            node.branches
              .map(&.pattern)
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
                destructurings.any? { |item| covers?(item, length) }
              end
            end

          covers_empty =
            node.branches
              .map(&.pattern)
              .select(Ast::ArrayLiteral)
              .any?(&.items.empty?)

          covers_infitiy =
            destructurings.any? { |item| spread?(item) }

          covered =
            covers_cases && covers_infitiy && covers_empty

          case_unnecessary_all.call(catch_all) if covered && catch_all
          case_not_covered.call if !covered && !catch_all
        elsif condition.name == "Tuple"
          destructured =
            node.branches.any? do |branch|
              case pattern = branch.pattern
              when Ast::TupleDestructuring
                exhaustive?(pattern)
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
