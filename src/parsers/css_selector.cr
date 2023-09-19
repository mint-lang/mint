module Mint
  class Parser
    def css_selector(only_definitions : Bool = false) : Ast::CssSelector?
      parse do |start_position|
        next if char == '/'

        selectors = list(
          terminator: '{',
          separator: ','
        ) { css_selector_name }

        next if selectors.empty?
        next unless char == '{'

        body =
          brackets(
            ->{ error :css_selector_expected_opening_bracket do
              expected "the opening bracket of a CSS selector", word
              snippet self
            end },
            ->{ error :css_selector_expected_closing_bracket do
              expected "the opening closing of a CSS selector", word
              snippet self
            end },
            ->(items : Array(Ast::Node)) {
              error :css_selector_expected_body do
                expected "the body of a CSS selector", word
                snippet self
              end if items.empty?
            }) do
            if only_definitions
              many { comment || css_definition }
            else
              many { css_node }
            end
          end

        next unless body

        Ast::CssSelector.new(
          selectors: selectors,
          from: start_position,
          to: position,
          file: file,
          body: body)
      end
    end
  end
end
