module Mint
  class Parser
    syntax_error ArrayLiteralExpectedTypeOrVariable
    syntax_error ArrayExpectedClosingBracket

    def array : Ast::ArrayLiteral?
      start do |start_position|
        skip unless char! '['

        whitespace
        items = list(
          terminator: ']',
          separator: ','
        ) { expression }.compact
        whitespace

        char "]", ArrayExpectedClosingBracket

        type = start do
          whitespace
          skip unless keyword "of"
          whitespace
          type_or_type_variable! ArrayLiteralExpectedTypeOrVariable
        end

        self << Ast::ArrayLiteral.new(
          from: start_position,
          items: items,
          type: type,
          to: position,
          input: data)
      end
    end
  end
end
