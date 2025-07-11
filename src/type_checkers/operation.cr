module Mint
  class TypeChecker
    def operation_type_mismatch(
      right : TypeChecker::Checkable,
      left : TypeChecker::Checkable,
      node : Ast::Node,
    )
      error! :operation_type_mismatch do
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
      side : String,
    )
      error! :operation_plus_type_mismatch do
        block do
          text "The type of the"
          bold side
          text "operand does not match the type of an operation."
        end

        block "I was expecting one of these types:"

        snippet "Number, String"
        snippet "Instead it is:", value
        snippet "The operation in question is here:", node
      end
    end

    def operation_numeric_type_mismatch(
      value : TypeChecker::Checkable,
      operator : String,
      node : Ast::Node,
      side : String,
    )
      error! :operation_numeric_type_mismatch do
        block do
          text "The type of the"
          bold side
          text "operand does not match the type of an operation."
        end

        expected TypeChecker::NUMBER, value
        snippet "The operation in question is here:", node
      end
    end

    def operation_bool_type_mismatch(
      value : TypeChecker::Checkable,
      operator : String,
      node : Ast::Node,
      side : String,
    )
      error! :operation_bool_type_mismatch do
        block do
          text "The type of the"
          bold side
          text "operand does not match the type of an operation."
        end

        expected TypeChecker::BOOL, value
        snippet "The operation in question is here:", node
      end
    end

    def check(node : Ast::Operation) : Checkable
      case node.operator
      when "!=", "=="
        right = resolve node.right
        left = resolve node.left

        operation_type_mismatch(
          right: right,
          left: left,
          node: node,
        ) unless Comparer.compare(left, right)

        BOOL
      when "&&", "||"
        right = resolve node.right
        left = resolve node.left

        operation_bool_type_mismatch(
          operator: node.operator,
          side: "left",
          value: left,
          node: node,
        ) unless Comparer.compare(left, BOOL)

        operation_bool_type_mismatch(
          operator: node.operator,
          side: "right",
          value: right,
          node: node,
        ) unless Comparer.compare(right, BOOL)

        left
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
      when "-", "*", "/", "%", "**", "<", ">", "<=", ">="
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

        case node.operator
        when "-", "*", "/", "%", "**"
          NUMBER
        else
          BOOL
        end
      when "|>"
        error! :operation_pipe_ambiguous do
          block "I cannot determine the order of the operands because the " \
                "pipe makes it ambiguous. Wrap operands in parentheses " \
                "to avoid ambiguity."

          snippet "The piped call in question is here:", node
        end
      when "or"
        right = resolve node.right
        left = resolve node.left

        if (left_node = node.left).is_a?(Ast::HtmlComponent)
          error! :html_component_fallback_not_async do
            block "Fallback can only be defined for async components but " \
                  "the component is not an async component."

            snippet "You tried to fall back here:", node
          end unless left_node.component_node.try(&.async?)

          error! :html_component_fallback_not_html do
            snippet "The fallback value for an async component needs to be:", HTML
            snippet "But it is:", right
            snippet "The fallback value is here:", node.right
          end unless Comparer.matches_any?(right, VALID_HTML)

          left_node.fallback_node = node.right

          HTML
        else
          case node.right
          when Ast::ReturnCall
            left
          else
            error! :operation_or_invalid do
              block do
                text "For the"
                bold "or"
                text "operation the"
                bold "left operand"
                text "is invalid."
              end

              snippet "I was expecting:", [MAYBE, RESULT, HTML].map(&.to_mint).join("\n")
              snippet "Instead it is:", left
              snippet "The operation in question is here:", node
            end unless Comparer.compare(left, MAYBE) ||
                       Comparer.compare(left, RESULT)

            type =
              case left.name
              when "Result"
                left.parameters[1]
              else
                left.parameters[0]
              end

            error! :operation_or_type_mismatch do
              block do
                text "The type of the default value does not match the type of the"
                text "parameter of the maybe."
              end

              expected type, right
              snippet "The operation in question is here:", node
            end unless Comparer.compare(type, right)

            type
          end
        end
      else
        raise Mint::Error.new(:never) # Can never happen
      end
    end
  end
end
