module Mint
  class Parser
    syntax_error GetExpectedOpeningBracket
    syntax_error GetExpectedClosingBracket
    syntax_error GetExpectedExpression
    syntax_error GetExpectedColon
    syntax_error GetExpectedName
    syntax_error GetExpectedType

    def get : Ast::Get | Nil
      start do |start_position|
        comment = self.comment

        skip unless keyword "get"
        whitespace

        name = variable! GetExpectedName
        whitespace

        char ':', GetExpectedColon
        whitespace

        type = type! GetExpectedType

        head_comments, body, tail_comments = block_with_comments(
          opening_bracket: GetExpectedOpeningBracket,
          closing_bracket: GetExpectedClosingBracket
        ) do
          expression! GetExpectedExpression
        end

        Ast::Get.new(
          head_comments: head_comments,
          tail_comments: tail_comments,
          from: start_position,
          comment: comment,
          to: position,
          input: data,
          name: name,
          body: body,
          type: type)
      end
    end
  end
end
