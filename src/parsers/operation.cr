module Mint
  class Parser
    syntax_error OperationExpectedExpression

    OPERATORS = {
      "|>" => 0,
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

    def operator : String | Nil
      start do
        whitespace
        operator = OPERATORS.keys.find { |item| keyword item }
        skip unless operator
        whitespace! SkipError
        operator
      end
    end

    def operation(left : Ast::Expression, operator : String) : Ast::Operation
      right = basic_expression! OperationExpectedExpression

      if next_operator = self.operator
        if OPERATORS[next_operator] > OPERATORS[operator]
          right = operation(right, next_operator)
        else
          return operation(
            Ast::Operation.new(
              right: right.as(Ast::Expression),
              left: left.as(Ast::Expression),
              operator: operator,
              from: left.from,
              to: right.to,
              input: data),
            next_operator)
        end
      end

      Ast::Operation.new(
        operator: operator,
        from: left.from,
        to: right.to,
        right: right,
        input: data,
        left: left)
    end
  end
end
