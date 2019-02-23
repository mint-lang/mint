module Mint
  class Parser
    syntax_error ForExpectedOpeningParentheses
    syntax_error ForExpectedClosingParentheses
    syntax_error ForExpectedOpeningBracket
    syntax_error ForExpectedClosingBracket
    syntax_error ForExpectedSubject
    syntax_error ForExpectedBody
    syntax_error ForExpectedOf

    def for_expression : Ast::For | Nil
      start do |start_position|
        skip unless keyword "for"
        whitespace! SkipError

        char '(', ForExpectedOpeningParentheses
        whitespace

        arguments = list(
          terminator: ')',
          separator: ','
        ) { variable }.compact

        whitespace
        keyword! "of", ForExpectedOf
        whitespace

        subject = expression! ForExpectedSubject

        whitespace
        char ')', ForExpectedClosingParentheses

        head_comments, body, tail_comments =
          block_with_comments(
            opening_bracket: ForExpectedOpeningBracket,
            closing_bracket: ForExpectedClosingBracket
          ) do
            expression! ForExpectedBody
          end

        whitespace
        condition = for_condition
        whitespace

        Ast::For.new(
          head_comments: head_comments,
          tail_comments: tail_comments,
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
