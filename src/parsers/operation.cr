module Mint
  class Parser
    syntax_error OperationExpectedExpression

    Operators = {
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
        operator = Operators.keys.find { |item| keyword item }
        skip unless operator
        whitespace
        operator
      end
    end

    def operation(left : Ast::Expression, operator : String) : Ast::Operation | Nil
      right = basic_expression! OperationExpectedExpression

      if next_operator = self.operator
        if Operators[next_operator] > Operators[operator]
          right = operation(right, next_operator)
        else
          return operation(
            Ast::Operation.new(
              operator: operator,
              from: left.from,
              to: right.to,
              right: right,
              input: data,
              left: left),
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
