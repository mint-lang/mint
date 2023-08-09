module Mint
  class Parser
    def css_selector(only_definitions : Bool = false) : Ast::CssSelector?
      start do |start_position|
        selectors = list(
          terminator: '{',
          separator: ','
        ) { css_selector_name }

        next if selectors.empty?
        next unless char == '{'

        body = block2(
          ->{ error :css_selector_expected_opening_bracket do
            expected "the opening bracket of a CSS selector", word
            snippet self
          end },
          ->{ error :css_selector_expected_closing_bracket do
            expected "the opening closing of a CSS selector", word
            snippet self
          end }) do
          if only_definitions
            many { comment || css_definition }
          else
            css_body
          end
        end

        next error :css_selector_expected_body do
          expected "the body of a CSS selector", word
          snippet self
        end if body.empty?

        self << Ast::CssSelector.new(
          selectors: selectors,
          from: start_position,
          to: position,
          input: data,
          body: body)
      end
    end

    def css_selector_name : String?
      if ampersand = char! '&'
        colon = char!(':')
        double_colon = keyword("::")
        dot = char!('.')
        bracket = char!('[')
      end

      name =
        gather { chars_until ',', '{', '}' }.presence.try(&.strip)

      return unless name || ampersand

      case
      when colon        then ":#{name}"
      when double_colon then "::#{name}"
      when dot          then ".#{name}"
      when bracket      then "[#{name}"
      else                   " #{name}"
      end
    end
  end
end
