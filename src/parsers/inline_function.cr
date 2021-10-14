module Mint
  class Parser
    syntax_error InlineFunctionExpectedClosingParentheses
    syntax_error InlineFunctionExpectedOpeningBracket
    syntax_error InlineFunctionExpectedClosingBracket
    syntax_error InlineFunctionExpectedExpression
    syntax_error InlineFunctionExpectedType

    def inline_function : Ast::InlineFunction?
      start do |start_position|
        next unless char! '('

        whitespace

        arguments = list(
          terminator: ')',
          separator: ','
        ) { argument }

        whitespace
        char ')', InlineFunctionExpectedClosingParentheses
        whitespace

        type =
          if char! ':'
            whitespace
            item = type_or_type_variable! InlineFunctionExpectedType
            whitespace
            item
          end

        body =
          code_block(
            opening_bracket: InlineFunctionExpectedOpeningBracket,
            closing_bracket: InlineFunctionExpectedClosingBracket,
            statement_error: InlineFunctionExpectedExpression)

        self << Ast::InlineFunction.new(
          arguments: arguments,
          from: start_position,
          to: position,
          input: data,
          body: body,
          type: type)
      end
    end
  end
end
