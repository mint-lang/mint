module Mint
  class TypeChecker
    def check(node : Ast::If) : Checkable
      condition =
        resolve node.condition

      variables =
        case item = node.condition
        when Ast::Statement
          case item.target
          when Ast::TupleDestructuring,
               Ast::ArrayDestructuring,
               Ast::TypeDestructuring,
               Ast::Discard
            destructure(item.target, condition)
          else
            case expression = item.expression
            when Ast::Variable
              type =
                if resolved = Comparer.compare(condition, MAYBE)
                  resolved.parameters.first
                elsif resolved = Comparer.compare(condition, RESULT)
                  resolved.parameters.last
                end

              if type
                expression.unboxed = true
                cache[expression] = type
                [{expression.value, cache[expression], expression}]
              end
            end
          end
        end || if Comparer.matches_any?(condition, [MAYBE, RESULT, HTML])
          [] of VariableScope
        end

      error! :if_condition_type_mismatch do
        block do
          text "The type of the"
          bold "condition of an if expression"
          text "is not a boolean but instead it is:"
        end

        snippet condition
        snippet "The condition in question is here:", node.condition
      end if variables.nil? && !Comparer.compare(condition, BOOL)

      truthy_item, falsy_item =
        node.branches

      variables.try(&.each do |variable|
        scope.add(truthy_item, variable[0], variable[2])
      end)

      truthy =
        resolve truthy_item

      if falsy_item
        falsy =
          resolve falsy_item

        error! :if_else_type_mismatch do
          block do
            text "The"
            bold "else branch of an if expression"
            text "does not match the type of the main branch."
          end

          expected truthy, falsy

          error_node =
            case falsy_item
            when Ast::Block
              falsy_item.expressions.last
            else
              falsy_item
            end

          snippet "The value for the else branch is here:",
            error_node.as(Ast::Node)
        end unless resolved = Comparer.compare_as_promises(truthy, falsy)

        resolved
      else
        error! :if_expected_else do
          block do
            text "This"
            bold "if expression"
            text "must have an"
            bold "else branch."
          end

          block "The else branch can only be omitted if the truthy branch returns one of:"
          snippet VALID_IF_TYPES.map(&.to_pretty).join("\n")
          block "but it returns"
          snippet truthy
          snippet node
        end unless Comparer.matches_any?(truthy, VALID_IF_TYPES)

        truthy
      end
    end
  end
end
