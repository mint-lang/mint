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

        body = expression! InlineFunctionExpectedExpression

        Ast::InlineFunction.new(
          body: body.as(Ast::Expression),
          arguments: arguments,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
