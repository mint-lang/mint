module Mint
  class Parser
    syntax_error InlineFunctionExpectedClosingParentheses
    syntax_error InlineFunctionExpectedOpeningBracket
    syntax_error InlineFunctionExpectedClosingBracket
    syntax_error InlineFunctionExpectedExpression
    syntax_error InlineFunctionExpectedArrow

    def inline_function : Ast::InlineFunction | Nil
      start do |start_position|
        skip unless char! '('

        whitespace

        arguments = list(
          terminator: ')',
          separator: ','
        ) { argument }.compact

        char ')', InlineFunctionExpectedClosingParentheses

        whitespace
        keyword! "=>", InlineFunctionExpectedArrow
        whitespace

        head_comments, body, tail_comments =
          block_with_comments(
            opening_bracket: InlineFunctionExpectedOpeningBracket,
            closing_bracket: InlineFunctionExpectedClosingBracket
          ) do
            expression! InlineFunctionExpectedExpression
          end

        Ast::InlineFunction.new(
          body: body.as(Ast::Expression),
          head_comments: head_comments,
          tail_comments: tail_comments,
          arguments: arguments,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
