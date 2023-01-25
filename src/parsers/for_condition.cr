module Mint
  class Parser
    syntax_error ForConditionExpectedOpeningBracket
    syntax_error ForConditionExpectedClosingBracket
    syntax_error ForConditionExpectedBody

    def for_condition : Ast::ForCondition?
      start do |start_position|
        next unless keyword "when"
        whitespace

        condition =
          code_block(
            opening_bracket: ForConditionExpectedOpeningBracket,
            closing_bracket: ForConditionExpectedClosingBracket,
            statement_error: ForConditionExpectedBody)

        self << Ast::ForCondition.new(
          condition: condition,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
