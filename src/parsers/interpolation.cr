module Mint
  class Parser
    def interpolation : Ast::Interpolation?
      start do |start_position|
        next unless keyword "\#{"

        whitespace
        next error :interpolation_expected_expression do
          expected "the expression of an interpolation", word
          snippet self
        end unless expression = self.expression

        whitespace
        next error :interpolation_expected_closing_bracket do
          expected "the closing bracket of an interpolation", word
          snippet self
        end unless char! '}'

        Ast::Interpolation.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
