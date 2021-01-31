module Mint
  class Parser
    syntax_error WithExpectedOpeningBracket
    syntax_error WithExpectedClosingBracket
    syntax_error WithExpectedExpression
    syntax_error WithExpectedModule

    def with_expression : Ast::With?
      start do |start_position|
        skip unless keyword "with"

        whitespace! SkipError

        name = type_id! WithExpectedModule

        head_comments, body, tail_comments = block_with_comments(
          opening_bracket: WithExpectedOpeningBracket,
          closing_bracket: WithExpectedClosingBracket
        ) do
          expression! WithExpectedExpression
        end

        self << Ast::With.new(
          body: body.as(Ast::Expression),
          head_comments: head_comments,
          tail_comments: tail_comments,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
