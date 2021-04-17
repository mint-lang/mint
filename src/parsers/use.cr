module Mint
  class Parser
    syntax_error UseExpectedOpeningBracket
    syntax_error UseExpectedClosingBracket
    syntax_error UseExpectedExpression
    syntax_error UseExpectedProvider
    syntax_error UseExpectedRecord

    def use : Ast::Use?
      start do |start_position|
        skip unless keyword "use"

        whitespace
        provider = type_id! UseExpectedProvider

        whitespace
        raise UseExpectedRecord unless item = record
        whitespace

        if keyword "when"
          condition = block(
            opening_bracket: UseExpectedOpeningBracket,
            closing_bracket: UseExpectedClosingBracket
          ) do
            expression! UseExpectedExpression
          end
        end

        self << Ast::Use.new(
          from: start_position,
          condition: condition,
          provider: provider,
          to: position,
          input: data,
          data: item)
      end
    end
  end
end
