module Mint
  class Parser
    def interpolation : Ast::Interpolation?
      interpolation { expression }
    end

    def interpolation(& : -> Ast::Node?) : Ast::Interpolation?
      parse do |start_position|
        next unless word! "\#{"
        whitespace

        next error :interpolation_expected_expression do
          expected "the expression of an interpolation", word
          snippet self
        end unless expression = yield
        whitespace

        next error :interpolation_expected_closing_bracket do
          expected "the closing bracket of an interpolation", word
          snippet self
        end unless char! '}'

        Ast::Interpolation.new(
          expression: expression,
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
