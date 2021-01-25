module Mint
  class Parser
    syntax_error FinallyExpectedOpeningBracket
    syntax_error FinallyExpectedClosingBracket
    syntax_error FinallyExpectedExpression

    def finally : Ast::Finally?
      start do |start_position|
        whitespace

        skip unless keyword "finally"

        head_comments, expression, tail_comments = block_with_comments(
          opening_bracket: FinallyExpectedOpeningBracket,
          closing_bracket: FinallyExpectedClosingBracket
        ) do
          expression! FinallyExpectedExpression
        end

        self << Ast::Finally.new(
          expression: expression.as(Ast::Expression),
          head_comments: head_comments,
          tail_comments: tail_comments,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
