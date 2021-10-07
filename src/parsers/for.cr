module Mint
  class Parser
    syntax_error ForExpectedOpeningParentheses
    syntax_error ForExpectedClosingParentheses
    syntax_error ForExpectedOpeningBracket
    syntax_error ForExpectedClosingBracket
    syntax_error ForExpectedSubject
    syntax_error ForExpectedBody
    syntax_error ForExpectedOf

    def for_expression : Ast::For?
      start do |start_position|
        next unless keyword "for"
        next unless whitespace?
        whitespace

        char '(', ForExpectedOpeningParentheses
        whitespace

        arguments = list(
          terminator: ')',
          separator: ','
        ) { variable }

        whitespace
        keyword! "of", ForExpectedOf
        whitespace

        subject = expression! ForExpectedSubject

        whitespace
        char ')', ForExpectedClosingParentheses
        whitespace

        body =
          code_block(
            opening_bracket: ForExpectedOpeningBracket,
            closing_bracket: ForExpectedClosingBracket,
            statement_error: ForExpectedBody)

        whitespace
        condition = for_condition
        whitespace

        self << Ast::For.new(
          condition: condition,
          arguments: arguments,
          from: start_position,
          subject: subject,
          to: position,
          input: data,
          body: body)
      end
    end
  end
end
