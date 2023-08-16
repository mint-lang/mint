module Mint
  class TypeChecker
    def check(node : Ast::If) : Checkable
      condition =
        resolve node.condition

      variables =
        case item = node.condition
        when Ast::Statement
          if item.target.is_a?(Ast::EnumDestructuring)
            destructure(item.target.as(Ast::EnumDestructuring), condition)
          end
        end || [] of Ast::Node

      error :if_condition_type_mismatch do
        block do
          text "The"
          bold "condition of an if expression"
          text "does not evaluate to a boolean."
        end

        expected BOOL, condition

        snippet node.condition
      end if variables.empty? && !Comparer.compare(condition, BOOL)

      truthy_item, falsy_item =
        node.branches

      if truthy_item.is_a?(Ast::Node)
        truthy =
          scope(variables) do
            resolve truthy_item.as(Ast::Node)
          end

        if falsy_item
          falsy =
            resolve falsy_item.as(Ast::Node)

          error :if_else_type_mismatch do
            block do
              text "The"
              bold "falsy (else) branch of an if expression"
              text "does not match the type of the truthy branch."
            end

            expected truthy, falsy
            snippet falsy_item.as(Ast::Node)
          end unless Comparer.compare(truthy, falsy)
        else
          error :if_expected_else do
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

        truthy
      else
        scope(variables) do
          resolve truthy_item
        end

        falsy_item.try { |data| resolve data }

        VOID
      end
    end
  end
end
