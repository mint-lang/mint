module Mint
  class Parser
    syntax_error SvgDirectiveExpectedOpeningParentheses
    syntax_error SvgDirectiveExpectedClosingParentheses
    syntax_error SvgDirectiveExpectedPath

    def svg_directive : Ast::Directives::Svg?
      start do |start_position|
        next unless keyword "@svg"

        char '(', SvgDirectiveExpectedOpeningParentheses
        whitespace

        path = gather { chars_until ')' }
        raise SvgDirectiveExpectedPath unless path

        whitespace
        char ')', SvgDirectiveExpectedClosingParentheses

        self << Ast::Directives::Svg.new(
          from: start_position,
          to: position,
          input: data,
          path: path)
      end
    end
  end
end
