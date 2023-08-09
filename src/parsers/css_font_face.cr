module Mint
  class Parser
    def css_font_face : Ast::CssFontFace?
      start do |start_position|
        next unless keyword "@font-face"

        definitions = block2(
          ->{ error :css_font_face_expected_opening_bracket do
            expected "the opening bracket of a CSS font-face rule", word
            snippet self
          end },
          ->{ error :css_font_face_expected_closing_bracket do
            expected "the closing bracket of a CSS font-face rule", word
            snippet self
          end }) do
          many { comment || css_definition }
        end

        next error :css_font_face_expected_definitions do
          expected "the definitions of a CSS font-face rule", word
          snippet self
        end if definitions.empty?

        Ast::CssFontFace.new(
          definitions: definitions,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
