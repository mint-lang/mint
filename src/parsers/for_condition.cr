module Mint
  class Parser
    syntax_error ForConditionExpectedOpeningBracket
    syntax_error ForConditionExpectedClosingBracket
    syntax_error ForConditionExpectedBody

    def for_condition : Ast::ForCondition?
      start do |start_position|
        next unless keyword "when"
        whitespace

        self << Ast::ForCondition.new(
          condition: code_block,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
