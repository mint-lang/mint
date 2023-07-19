module Mint
  class Parser
    syntax_error FormatDirectiveExpectedOpeningBracket
    syntax_error FormatDirectiveExpectedClosingBracket
    syntax_error FormatDirectiveExpectedExpression

    def highlight_directive : Ast::Directives::Highlight?
      start do |start_position|
        next unless keyword "@highlight"

        content =
          code_block(
            opening_bracket: FormatDirectiveExpectedOpeningBracket,
            closing_bracket: FormatDirectiveExpectedClosingBracket,
            statement_error: FormatDirectiveExpectedExpression)

        self << Ast::Directives::Highlight.new(
          from: start_position,
          content: content,
          to: position,
          input: data)
      end
    end
  end
end
