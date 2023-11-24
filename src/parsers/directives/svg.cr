module Mint
  class Parser
    def svg_directive : Ast::Directives::Svg?
      parse do |start_position|
        next unless keyword! "@svg"

        next error :svg_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of an svg directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :svg_directive_expected_path do
          expected "the path (to the svg) of an svg directive", word
          snippet self
        end unless path = gather { chars { char != ')' } }.presence.try(&.strip)
        whitespace

        next error :svg_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of an svg directive", word
          snippet self
        end unless char! ')'

        Ast::Directives::Svg.new(
          from: start_position,
          to: position,
          file: file,
          path: path)
      end
    end
  end
end
