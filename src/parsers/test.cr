module Mint
  class Parser
    syntax_error TestExpectedOpeningBracket
    syntax_error TestExpectedClosingBracket
    syntax_error TestExpectedExpression
    syntax_error TestExpectedName

    def test : Ast::Test?
      start do |start_position|
        skip unless keyword "test"

        whitespace

        name = string_literal! TestExpectedName,
          with_interpolation: false

        whitespace

        head_comments, expression, tail_comments = block_with_comments(
          opening_bracket: TestExpectedOpeningBracket,
          closing_bracket: TestExpectedClosingBracket
        ) do
          expression! TestExpectedExpression
        end

        self << Ast::Test.new(
          head_comments: head_comments,
          tail_comments: tail_comments,
          expression: expression,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
