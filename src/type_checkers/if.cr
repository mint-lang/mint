module Mint
  class TypeChecker
    type_error IfConditionTypeMismatch
    type_error IfElseTypeMismatch

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

      raise IfConditionTypeMismatch, {
        "node"     => node.condition,
        "got"      => condition,
        "expected" => BOOL,
      } if variables.empty? && !Comparer.compare(condition, BOOL)

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

          raise IfElseTypeMismatch, {
            "node"     => falsy_item.as(Ast::Node),
            "expected" => truthy,
            "got"      => falsy,
          } unless Comparer.compare(truthy, falsy)
        end

        truthy
      else
        scope(variables) do
          resolve truthy_item
        end

        falsy_item.try { |data| resolve data }

        NEVER
      end
    end
  end
end
