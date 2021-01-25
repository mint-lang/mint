module Mint
  class Parser
    syntax_error ThenExpectedOpeningBracket
    syntax_error ThenExpectedClosingBracket
    syntax_error ThenExpectedExpression

    def then_block : Ast::Then?
      start do |start_position|
        whitespace

        skip unless keyword "then"

        head_comments, expression, tail_comments = block_with_comments(
          opening_bracket: ThenExpectedOpeningBracket,
          closing_bracket: ThenExpectedClosingBracket
        ) do
          expression! ThenExpectedExpression
        end

        self << Ast::Then.new(
          expression: expression.as(Ast::Expression),
          head_comments: head_comments,
          tail_comments: tail_comments,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
