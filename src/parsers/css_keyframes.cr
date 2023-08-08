module Mint
  class Parser
    def css_keyframes : Ast::CssKeyframes?
      parse do |start_position|
        next unless word! "@keyframes"
        whitespace

        name =
          gather { chars { char != '{' } }.presence.try(&.strip)

        next error :css_keyframes_expected_name do
          expected "the name of a CSS keyframes rule", word
          snippet self
        end unless name

        selectors = brackets(
          ->{ error :css_keyframes_expected_opening_bracket do
            expected "the opening bracket of a CSS keyframes rule", word
            snippet self
          end },
          ->{ error :css_keyframes_expected_closing_bracket do
            expected "the closing bracket of a CSS keyframes rule", word
            snippet self
          end },
          ->(items : Array(Ast::Node)) {
            error :css_keyframes_expected_selectors do
              expected "the selectors of a CSS keyframes rule", word
              snippet self
            end if items.all?(Ast::Comment)
          }) {
          many { comment || css_selector(only_definitions: true) }
        }

        next unless selectors

        Ast::CssKeyframes.new(
          from: start_position,
          selectors: selectors,
          to: position,
          file: file,
          name: name)
      end
    end
  end
end
