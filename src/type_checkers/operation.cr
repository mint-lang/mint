module Mint
  class TypeChecker
    def operation_type_mismatch(
      right : TypeChecker::Checkable,
      left : TypeChecker::Checkable,
      node : Ast::Node
    )
      error :operation_type_mismatch do
        block do
          text "The type of the right operand does not match the type of the"
          text "left operand."
        end

        expected left, right
        snippet node
      end
    end

    def operation_plus_type_mismatch(
      value : TypeChecker::Checkable,
      node : Ast::Node,
      side : String
    )
      error :operation_plus_type_mismatch do
        block do
          text "The type of the"
          bold side
          text "operand does not match the type of the operation:"
          bold "+"
        end

        block "I was expecting one of these types:"

        snippet "Number, String"
        snippet "Instead it is:", value
        snippet node
      end
    end

    def operation_numeric_type_mismatch(
      value : TypeChecker::Checkable,
      operator : String,
      node : Ast::Node,
      side : String
    )
      error :operation_numeric_type_mismatch do
        block do
          text "The type of the"
          bold side
          text "operand does not match the type of the operation:"
          bold operator
        end

        expected TypeChecker::NUMBER, value
        snippet node
      end
    end

    def check(node : Ast::Operation) : Checkable
      case node.operator
      when "!=", "==", "<", ">", "<=", ">=", "&&", "||"
        right = resolve node.right
        left = resolve node.left

        operation_type_mismatch(
          right: right,
          left: left,
          node: node,
        ) unless Comparer.compare(left, right)

        BOOL
      when "+"
        right = resolve node.right
        left = resolve node.left

        operation_plus_type_mismatch(
          side: "left",
          value: left,
          node: node,
        ) unless Comparer.compare(left, NUMBER) ||
                 Comparer.compare(left, STRING)

        operation_plus_type_mismatch(
          side: "right",
          value: right,
          node: node,
        ) unless Comparer.compare(right, NUMBER) ||
                 Comparer.compare(right, STRING)

        operation_type_mismatch(
          right: right,
          left: left,
          node: node,
        ) unless Comparer.compare(left, right)

        left
      when "-", "*", "/", "%", "**"
        right = resolve node.right
        left = resolve node.left

        operation_numeric_type_mismatch(
          operator: node.operator,
          side: "left",
          value: left,
          node: node,
        ) unless Comparer.compare(left, NUMBER)

        operation_numeric_type_mismatch(
          operator: node.operator,
          side: "right",
          value: right,
          node: node,
        ) unless Comparer.compare(right, NUMBER)

        operation_type_mismatch(
          right: right,
          left: left,
          node: node,
        ) unless Comparer.compare(left, right)

        NUMBER
      when "|>"
        error :operation_pipe_ambiguous do
          block "We cannot determine the order of the operands because the pipe makes it ambiguous."
          block "Wrap operands in parentheses to avoid ambiguity."

          snippet node
        end
      when "or"
        right = resolve node.right
        left = resolve node.left

        case node.right
        when Ast::ReturnCall
          left
        else
          error :operation_or_not_maybe_or_result do
            block do
              text "For the"
              bold "or"
              text "operation the"
              bold "left operand"
              text "is invalid."
            end

            expected MAYBE, left
            snippet node
          end unless Comparer.compare(left, MAYBE) ||
                     Comparer.compare(left, RESULT)

          type =
            case left.name
            when "Result"
              left.parameters[1]
            else
              left.parameters[0]
            end

          error :operation_or_type_mismatch do
            block do
              text "The type of the default value does not match the type of the"
              text "parameter of the maybe."
            end

            expected type, right
            snippet node
          end unless Comparer.compare(type, right)

          type
        end
      else
        raise Mint::Error2.new(:never) # Can never happen
      end
    end
  end
end
