module Mint
  class Parser
    syntax_error ParenthesizedExpressionExpectedClosingParentheses
    syntax_error ParenthesizedExpressionExpectedExpression

    def parenthesized_expression : Ast::ParenthesizedExpression?
      start do |start_position|
        skip unless char! '('

        whitespace
        expression = expression! ParenthesizedExpressionExpectedExpression
        whitespace

        char ')', ParenthesizedExpressionExpectedClosingParentheses

        self << Ast::ParenthesizedExpression.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
