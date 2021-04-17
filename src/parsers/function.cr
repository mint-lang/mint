module Mint
  class Parser
    syntax_error FunctionExpectedClosingParentheses
    syntax_error FunctionExpectedOpeningBracket
    syntax_error FunctionExpectedClosingBracket
    syntax_error FunctionExpectedTypeOrVariable
    syntax_error FunctionExpectedExpression
    syntax_error FunctionExpectedName

    def function : Ast::Function?
      start do |start_position|
        comment = self.comment

        skip unless keyword "fun"
        whitespace

        name = variable! FunctionExpectedName, track: false
        whitespace

        arguments = [] of Ast::Argument

        if char! '('
          whitespace

          arguments.concat list(
            terminator: ')',
            separator: ','
          ) { argument }.compact

          whitespace
          char ')', FunctionExpectedClosingParentheses
        end

        whitespace

        type =
          if char! ':'
            whitespace
            item = type_or_type_variable! FunctionExpectedTypeOrVariable
            whitespace
            item
          end

        head_comments, body, tail_comments = block_with_comments(
          opening_bracket: FunctionExpectedOpeningBracket,
          closing_bracket: FunctionExpectedClosingBracket
        ) do
          expression! FunctionExpectedExpression
        end

        end_position = position

        whitespace

        self << Ast::Function.new(
          body: body.as(Ast::Expression),
          head_comments: head_comments,
          tail_comments: tail_comments,
          arguments: arguments,
          from: start_position,
          comment: comment,
          to: end_position,
          where: where,
          input: data,
          name: name,
          type: type)
      end
    end
  end
end
