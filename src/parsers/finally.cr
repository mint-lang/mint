module Mint
  class Parser
    syntax_error FinallyExpectedOpeningBracket
    syntax_error FinallyExpectedClosingBracket
    syntax_error FinallyExpectedExpression

    def finally : Ast::Finally?
      start do |start_position|
        whitespace

        next unless keyword "finally"

        expression = code_block(
          opening_bracket: FinallyExpectedOpeningBracket,
          closing_bracket: FinallyExpectedClosingBracket,
          statement_error: FinallyExpectedExpression,
        )

        self << Ast::Finally.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
