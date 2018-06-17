module Mint
  class Parser
    syntax_error FunctionExpectedClosingParentheses
    syntax_error FunctionExpectedOpeningBracket
    syntax_error FunctionExpectedClosingBracket
    syntax_error FunctionExpectedTypeOrVariable
    syntax_error FunctionExpectedExpression
    syntax_error FunctionExpectedColon
    syntax_error FunctionExpectedName

    def function : Ast::Function | Nil
      start do |start_position|
        comment = self.comment
        whitespace

        skip unless keyword "fun"

        whitespace
        name = variable! FunctionExpectedName
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
        char ':', FunctionExpectedColon
        whitespace

        type = type_or_type_variable! FunctionExpectedTypeOrVariable

        body = block(
          opening_bracket: FunctionExpectedOpeningBracket,
          closing_bracket: FunctionExpectedClosingBracket
        ) do
          expression! FunctionExpectedExpression
        end

        end_position = position

        whitespace

        Ast::Function.new(
          body: body.as(Ast::Expression),
          arguments: arguments,
          from: start_position,
          comment: comment,
          to: end_position,
          wheres: where,
          input: data,
          name: name,
          type: type)
      end
    end
  end
end
