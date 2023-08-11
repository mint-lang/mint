module Mint
  class Parser
    def svg_directive : Ast::Directives::Svg?
      start do |start_position|
        next unless keyword "@svg"

        next error :svg_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of an svg directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :svg_directive_expected_path do
          expected "the path of an svg directive", word
          snippet self
        end unless path = gather { chars_until ')' }

        whitespace
        next error :svg_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of an svg directive", word
          snippet self
        end unless char! ')'

        self << Ast::Directives::Svg.new(
          from: start_position,
          to: position,
          input: data,
          path: path)
      end
    end
  end
end
