module Mint
  class Parser
    syntax_error FormatDirectiveExpectedOpeningBracket
    syntax_error FormatDirectiveExpectedClosingBracket
    syntax_error FormatDirectiveExpectedExpression

    def format_directive : Ast::Directives::Format?
      start do |start_position|
        next unless keyword "@format"

        content =
          code_block(
            opening_bracket: FormatDirectiveExpectedOpeningBracket,
            closing_bracket: FormatDirectiveExpectedClosingBracket,
            statement_error: FormatDirectiveExpectedExpression)

        self << Ast::Directives::Format.new(
          from: start_position,
          content: content,
          to: position,
          input: data)
      end
    end
  end
end
