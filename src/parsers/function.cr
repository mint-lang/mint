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
          code_block(
            opening_bracket: FunctionExpectedOpeningBracket,
            closing_bracket: FunctionExpectedClosingBracket,
            statement_error: FunctionExpectedExpression)

        self << Ast::Function.new(
          arguments: arguments,
          from: start_position,
          comment: comment,
          to: position,
          input: data,
          body: body,
          name: name,
          type: type)
      end
    end
  end
end
