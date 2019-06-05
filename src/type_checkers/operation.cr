module Mint
  class TypeChecker
    type_error OperationNumericTypeMismatch
    type_error OperationPlusTypeMismatch
    type_error OperationTypeMismatch

    def check(node : Ast::Operation) : Checkable
      case node.operator
      when "!=", "==", "<", ">", "<=", ">=", "&&", "||"
        right = resolve node.right
        left = resolve node.left

        raise OperationTypeMismatch, {
          "right" => right,
          "left"  => left,
          "node"  => node,
        } unless Comparer.compare(left, right)

        BOOL
      when "+"
        right = resolve node.right
        left = resolve node.left

        raise OperationPlusTypeMismatch, {
          "side"  => "left",
          "value" => left,
          "node"  => node,
        } unless Comparer.compare(left, NUMBER) ||
                 Comparer.compare(left, STRING)

        raise OperationPlusTypeMismatch, {
          "side"  => "right",
          "value" => right,
          "node"  => node,
        } unless Comparer.compare(right, NUMBER) ||
                 Comparer.compare(right, STRING)

        raise OperationTypeMismatch, {
          "right" => right,
          "left"  => left,
          "node"  => node,
        } unless Comparer.compare(left, right)

        left
      when "-", "*", "/", "%"
        right = resolve node.right
        left = resolve node.left

        raise OperationNumericTypeMismatch, {
          "operator" => node.operator,
          "side"     => "left",
          "value"    => left,
          "node"     => node,
        } unless Comparer.compare(left, NUMBER)

        raise OperationNumericTypeMismatch, {
          "operator" => node.operator,
          "side"     => "right",
          "value"    => right,
          "node"     => node,
        } unless Comparer.compare(right, NUMBER)

        raise OperationTypeMismatch, {
          "right" => right,
          "left"  => left,
          "node"  => node,
        } unless Comparer.compare(left, right)

        NUMBER
      else
        raise Mint::TypeError # Can never happen
      end
    end
  end
end
