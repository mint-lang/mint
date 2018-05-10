module Mint
  class Parser
    syntax_error FinallyExpectedOpeningBracket
    syntax_error FinallyExpectedClosingBracket
    syntax_error FinallyExpectedExpression

    def finally : Ast::Finally | Nil
      start do |start_position|
        whitespace

        skip unless keyword "finally"

        expression = block(
          opening_bracket: FinallyExpectedOpeningBracket,
          closing_bracket: FinallyExpectedClosingBracket
        ) do
          expression! FinallyExpectedExpression
        end

        Ast::Finally.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
