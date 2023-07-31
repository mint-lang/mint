module Mint
  class Parser
    syntax_error OperationExpectedExpression

    OPERATORS = {
      "|>" => 0,
      "or" => 0,
      "!=" => 10,
      "==" => 10,

      "<=" => 11,
      "<"  => 11,
      ">=" => 11,
      ">"  => 11,

      "-" => 13,
      "+" => 13,

      "*" => 14,
      "/" => 14,
      "%" => 14,

      "**" => 15,

      "&&" => 6,
      "||" => 5,
      "!"  => 16,
    }

    def operator : String?
      start do
        whitespace
        saved_position = position
        operator = OPERATORS.keys.find { |item| keyword item }
        next unless operator
        next unless whitespace?
        ast.operators << {saved_position, saved_position + operator.size}
        whitespace
        operator
      end
    end

    def operation(left : Ast::Expression, operator : String) : Ast::Operation
      right = array_access_or_call(basic_expression!(OperationExpectedExpression))

      if next_operator = self.operator
        if OPERATORS[next_operator] > OPERATORS[operator]
          right = operation(right, next_operator)
        else
          return operation(
            self << Ast::Operation.new(
              right: right,
              left: left,
              operator: operator,
              from: left.from,
              to: right.to,
              input: data),
            next_operator)
        end
      end

      self << Ast::Operation.new(
        operator: operator,
        from: left.from,
        to: right.to,
        right: right,
        input: data,
        left: left)
    end
  end
end
