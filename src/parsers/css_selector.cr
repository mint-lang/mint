module Mint
  class Parser
    syntax_error CssSelectorExpectedOpeningBracket
    syntax_error CssSelectorExpectedClosingBracket

    def css_selector(only_definitions : Bool = false) : Ast::CssSelector?
      start do |start_position|
        selectors = list(
          terminator: '{',
          separator: ','
        ) { css_selector_name }

        next if selectors.empty?
        next unless char == '{'

        body = block(
          opening_bracket: CssSelectorExpectedOpeningBracket,
          closing_bracket: CssSelectorExpectedClosingBracket) do
          if only_definitions
            many { comment || css_definition }
          else
            css_body
          end
        end

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
        gather { chars "^,{}" }.presence.try(&.strip)

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
