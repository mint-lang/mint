module Mint
  class Parser
    syntax_error FunctionExpectedClosingParentheses
    syntax_error FunctionExpectedOpeningBracket
    syntax_error FunctionExpectedClosingBracket
    syntax_error FunctionExpectedTypeOrVariable
    syntax_error FunctionExpectedExpression
    syntax_error FunctionExpectedName

    def code_block : Ast::Block?
      start do |start_position|
        char '{', SyntaxError
        whitespace

        statements =
          many { comment || statement(:none) }

        whitespace
        char '}', SyntaxError

        self << Ast::Block.new(
          statements: statements,
          from: start_position,
          to: position,
          input: data)
      end
    end

    def function : Ast::Function?
      start do |start_position|
        comment = self.comment

        next unless keyword "fun"
        whitespace

        name = variable! FunctionExpectedName, track: false
        whitespace

        arguments = [] of Ast::Argument

        if char! '('
          whitespace

          arguments.concat list(
            terminator: ')',
            separator: ','
          ) { argument }

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

        body =
          code_block

        # head_comments, body, tail_comments = block_with_comments(
        #   opening_bracket: FunctionExpectedOpeningBracket,
        #   closing_bracket: FunctionExpectedClosingBracket
        # ) do
        #   expression! FunctionExpectedExpression
        # end

        end_position = position

        whitespace

        self << Ast::Function.new(
          head_comments: [] of Ast::Comment,
          tail_comments: [] of Ast::Comment,
          body: body.as(Ast::Expression),
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
