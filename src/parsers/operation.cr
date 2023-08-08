module Mint
  class Parser
    # Parses an operation, switching the operands if the precedence of the
    # next operation is higher than the current one. The precedences can be
    # found in the operator parser file.
    #
    # Operations can be chained recursively with this method as seen below.
    def operation(left : Ast::Node, operator : String) : Ast::Operation?
      parse do
        next error :operation_expected_expression do
          expected "the right side expression of an operation", word
          snippet self
        end unless right = base_expression

        if next_operator = self.operator
          if OPERATORS[next_operator] > OPERATORS[operator]
            right = operation(right, next_operator)
          else
            return operation(
              Ast::Operation.new(
                operator: operator,
                from: left.from,
                to: right.to,
                right: right,
                file: file,
                left: left),
              next_operator)
          end
        end

        next unless right

        Ast::Operation.new(
          operator: operator,
          from: left.from,
          to: right.to,
          right: right,
          file: file,
          left: left)
      end
    end
  end
end
