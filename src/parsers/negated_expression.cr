module Mint
  class Parser
    syntax_error NegatedExpressionExpectedExpression

    def negated_expression : Ast::NegatedExpression?
      start do |start_position|
        negations = gather { chars &.==('!') }
        next unless negations

        negations =
          negations.size % 2 == 0 ? "!!" : "!"

        expression = expression! NegatedExpressionExpectedExpression

        self << Ast::NegatedExpression.new(
          expression: expression,
          negations: negations,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
