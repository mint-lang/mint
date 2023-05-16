module Mint
  class TypeChecker
    type_error OperationNumericTypeMismatch
    type_error OperationTypeMismatch

    type_error OperationPlusTypeMismatch
    type_error OperationPipeAmbiguous

    type_error OperationOrNotMaybeOrResult
    type_error OperationOrTypeMismatch

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
      when "-", "*", "/", "%", "**"
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
      when "|>"
        raise OperationPipeAmbiguous, {
          "node" => node,
        }
      when "or"
        right = resolve node.right
        left = resolve node.left

        case node.right
        when Ast::ReturnCall
          left
        else
          raise OperationOrNotMaybeOrResult, {
            "expected" => MAYBE,
            "node"     => node,
            "got"      => left,
          } unless Comparer.compare(left, MAYBE) ||
                   Comparer.compare(left, RESULT)

          expected =
            case left.name
            when "Result"
              left.parameters[1]
            else
              left.parameters[0]
            end

          raise OperationOrTypeMismatch, {
            "expected" => expected,
            "got"      => right,
            "node"     => node,
          } unless Comparer.compare(expected, right)

          expected
        end
      else
        raise Mint::TypeError # Can never happen
      end
    end
  end
end
