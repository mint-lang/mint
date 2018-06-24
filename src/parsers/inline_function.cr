module Mint
  class Parser
    syntax_error InlineFunctionExpectedExpression
    syntax_error InlineFunctionExpectedArrow

    def inline_function : Ast::InlineFunction | Nil
      start do |start_position|
        skip unless char! '\\'

        whitespace

        arguments = list(
          terminator: ')',
          separator: ','
        ) { argument }.compact

        whitespace
        keyword! "=>", InlineFunctionExpectedArrow
        whitespace

        head_comments = many { comment }.compact

        body = expression! InlineFunctionExpectedExpression

        tail_comments = many { comment }.compact

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
