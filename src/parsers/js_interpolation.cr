module Mint
  class Parser
    syntax_error JsInterpolationExpectedClosingBracket
    syntax_error JsInterpolationExpectedExpression

    def js_interpolation
      start do
        skip unless keyword "\#{"

        whitespace
        expression = self.expression! JsInterpolationExpectedExpression
        whitespace

        char "}", JsInterpolationExpectedClosingBracket

        expression
      end
    end
  end
end
