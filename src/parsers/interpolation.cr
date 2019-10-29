module Mint
  class Parser
    syntax_error InterpolationExpectedClosingBracket
    syntax_error InterpolationExpectedExpression

    def interpolation : Ast::Interpolation | Nil
      start do |start_position|
        skip unless keyword "\#{"

        whitespace
        expression = expression! InterpolationExpectedExpression
        whitespace

        char "}", InterpolationExpectedClosingBracket

        Ast::Interpolation.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
