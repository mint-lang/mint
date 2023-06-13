module Mint
  class Parser
    syntax_error TestExpectedOpeningBracket
    syntax_error TestExpectedClosingBracket
    syntax_error TestExpectedExpression
    syntax_error TestExpectedName

    def test : Ast::Test?
      start do |start_position|
        next unless keyword "test"

        whitespace

        name = string_literal! TestExpectedName,
          with_interpolation: false

        whitespace

        expression =
          code_block(
            opening_bracket: TestExpectedOpeningBracket,
            closing_bracket: TestExpectedClosingBracket,
            statement_error: TestExpectedExpression)

        self << Ast::Test.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
