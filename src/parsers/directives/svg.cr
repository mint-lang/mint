module Mint
  class Parser
    syntax_error SvgDirectiveExpectedOpeningBracket
    syntax_error SvgDirectiveExpectedClosingBracket
    syntax_error SvgDirectiveExpectedPath

    def svg_directive : Ast::Directives::Svg | Nil
      start do |start_position|
        skip unless keyword "@svg"

        char '(', SvgDirectiveExpectedOpeningBracket
        whitespace
        path = string_literal! SvgDirectiveExpectedPath
        whitespace
        char ')', SvgDirectiveExpectedClosingBracket

        Ast::Directives::Svg.new(
          path: path.string_value,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
