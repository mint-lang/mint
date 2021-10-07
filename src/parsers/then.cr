module Mint
  class Parser
    syntax_error ThenExpectedOpeningBracket
    syntax_error ThenExpectedClosingBracket
    syntax_error ThenExpectedExpression

    def then_block : Ast::Then?
      start do |start_position|
        whitespace

        next unless keyword "then"

        expression =
          code_block(
            opening_bracket: ThenExpectedOpeningBracket,
            closing_bracket: ThenExpectedClosingBracket,
            statement_error: ThenExpectedExpression)

        self << Ast::Then.new(
          expression: expression.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
