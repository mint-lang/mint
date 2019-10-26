module Mint
  class TypeChecker
    type_error IfConditionTypeMismatch
    type_error IfElseTypeMismatch

    def check(node : Ast::If) : Checkable
      condition =
        resolve node.condition

      raise IfConditionTypeMismatch, {
        "node"     => node.condition,
        "got"      => condition,
        "expected" => BOOL,
      } unless Comparer.compare(condition, BOOL)

      truthy_item, falsy_item =
        node.branches

      if truthy_item.is_a?(Ast::Node) &&
         falsy_item.is_a?(Ast::Node)
        truthy =
          resolve truthy_item.as(Ast::Node)

        falsy =
          resolve falsy_item.as(Ast::Node)

        raise IfElseTypeMismatch, {
          "node"     => falsy_item.as(Ast::Node),
          "expected" => truthy,
          "got"      => falsy,
        } unless Comparer.compare(truthy, falsy)

        truthy
      else
        resolve truthy_item
        falsy_item.try { |data| resolve data }

        NEVER
      end
    end
  end
end
