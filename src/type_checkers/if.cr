module Mint
  class TypeChecker
    def check(node : Ast::If) : Checkable
      condition =
        resolve node.condition

      variables, await =
        case item = node.condition
        when Ast::Statement
          if item.target.is_a?(Ast::TypeDestructuring)
            {destructure(item.target.as(Ast::TypeDestructuring), condition), item.await}
          end
        end || {[] of VariableScope, false}

      error! :if_condition_type_mismatch do
        block do
          text "The type of the"
          bold "condition of an if expression"
          text "is not a boolean but instead it is:"
        end

        snippet condition
        snippet "The condition in question is here:", node.condition
      end if variables.empty? && !Comparer.compare(condition, BOOL)

      truthy_item, falsy_item =
        node.branches

      variables.each do |var|
        scope.add(truthy_item, var[0], var[2])
      end

      truthy =
        resolve truthy_item

      if falsy_item
        falsy =
          resolve falsy_item

        error! :if_else_type_mismatch do
          block do
            text "The"
            bold "falsy (else) branch of an if expression"
            text "does not match the type of the truthy branch."
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
        end unless Comparer.compare(truthy, falsy)
      else
        error! :if_expected_else do
          block do
            text "This"
            bold "if expression"
            text "must have an"
            bold "else branch."
          end

          block "The elese branch can be omitted if the truthy branch returns one of:"
          snippet VALID_IF_TYPES.map(&.to_pretty).join("\n")
          block "but it returns"
          snippet truthy

          snippet node
        end unless Comparer.matches_any?(truthy, VALID_IF_TYPES)
      end

      if await
        Type.new("Promise", [truthy] of Checkable)
      else
        truthy
      end
    end
  end
end
