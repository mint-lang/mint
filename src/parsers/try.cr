module Mint
  class Parser
    syntax_error TryExpectedOpeningBracket
    syntax_error TryExpectedClosingBracket
    syntax_error TryExpectedStatement

    def try_expression : Ast::Try | Nil
      start do |start_position|
        skip unless keyword "try"

        statements = block(
          opening_bracket: TryExpectedOpeningBracket,
          closing_bracket: TryExpectedClosingBracket
        ) do
          items = many { statement }.compact
          raise TryExpectedStatement if items.empty?
          items
        end

        whitespace

        catches = many { catch }.compact

        Ast::Try.new(
          statements: statements,
          from: start_position,
          catches: catches,
          to: position,
          input: data)
      end
    end
  end
end
