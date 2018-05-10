module Mint
  class Parser
    syntax_error WithExpectedOpeningBracket
    syntax_error WithExpectedClosingBracket
    syntax_error WithExpectedExpression
    syntax_error WithExpectedModule

    def with_expression : Ast::With | Nil
      start do |start_position|
        skip unless keyword "with"

        whitespace
        name = type_id! WithExpectedModule

        body = block(
          opening_bracket: WithExpectedOpeningBracket,
          closing_bracket: WithExpectedClosingBracket
        ) do
          expression! WithExpectedExpression
        end

        Ast::With.new(
          from: start_position,
          to: position,
          input: data,
          name: name,
          body: body)
      end
    end
  end
end
