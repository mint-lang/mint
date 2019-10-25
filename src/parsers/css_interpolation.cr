module Mint
  class Parser
    syntax_error CssInterpolationExpectedClosingBracket
    syntax_error CssInterpolationExpectedExpression

    def css_interpolation : Ast::CssInterpolation | Nil
      start do |start_position|
        skip unless keyword "\#{"

        whitespace
        expression = expression! CssInterpolationExpectedExpression
        whitespace

        char "}", CssInterpolationExpectedClosingBracket

        Ast::CssInterpolation.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
