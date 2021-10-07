module Mint
  class Parser
    syntax_error GetExpectedOpeningBracket
    syntax_error GetExpectedClosingBracket
    syntax_error GetExpectedExpression
    syntax_error GetExpectedColon
    syntax_error GetExpectedName
    syntax_error GetExpectedType

    def get : Ast::Get?
      start do |start_position|
        comment = self.comment

        next unless keyword "get"
        whitespace

        name = variable! GetExpectedName, track: false
        whitespace

        type =
          if char! ':'
            whitespace
            item = type_or_type_variable! GetExpectedType
            whitespace
            item
          end

        body =
          code_block(
            opening_bracket: GetExpectedOpeningBracket,
            closing_bracket: GetExpectedClosingBracket,
            statement_error: GetExpectedExpression)

        whitespace

        self << Ast::Get.new(
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
