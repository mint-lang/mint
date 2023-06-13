module Mint
  class Parser
    syntax_error InlineDirectiveExpectedOpeningParentheses
    syntax_error InlineDirectiveExpectedClosingParentheses
    syntax_error InlineDirectiveExpectedPath

    def inline_directive : Ast::Directives::Inline?
      start do |start_position|
        next unless keyword "@inline"

        char '(', InlineDirectiveExpectedOpeningParentheses
        whitespace

        path = gather { chars_until ')' }
        raise InlineDirectiveExpectedPath unless path

        whitespace
        char ')', InlineDirectiveExpectedClosingParentheses

        self << Ast::Directives::Inline.new(
          from: start_position,
          to: position,
          input: data,
          path: path)
      end
    end
  end
end
