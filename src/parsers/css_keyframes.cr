module Mint
  class Parser
    def css_keyframes : Ast::CssKeyframes?
      start do |start_position|
        next unless keyword "@keyframes"

        whitespace

        name =
          gather { chars_until '{' }.presence.try(&.strip)

        next error :css_keyframes_expected_name do
          expected "the name of a CSS keyframes rule", word
          snippet self
        end unless name

        selectors = block2(
          ->{ error :css_keyframes_expected_opening_bracket do
            expected "the opening bracket of a CSS keyframes rule", word
            snippet self
          end },
          ->{ error :css_keyframes_expected_closing_bracket do
            expected "the closing bracket of a CSS keyframes rule", word
            snippet self
          end }) do
          many { comment || css_selector(only_definitions: true) }
        end

        next error :css_keyframes_expected_selectors do
          expected "the selectors of a CSS keyframes rule", word
          snippet self
        end if selectors.empty?

        Ast::CssKeyframes.new(
          from: start_position,
          selectors: selectors,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
