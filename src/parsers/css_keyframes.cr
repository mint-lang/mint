module Mint
  class Parser
    syntax_error CssKeyframesExpectedOpeningBracket
    syntax_error CssKeyframesExpectedClosingBracket
    syntax_error CssKeyframesExpectedName

    def css_keyframes : Ast::CssKeyframes?
      start do |start_position|
        next unless keyword("@keyframes", true)

        whitespace

        name =
          gather { chars_until '{' }.presence.try(&.strip)

        raise CssKeyframesExpectedName unless name

        selectors = block(
          opening_bracket: CssKeyframesExpectedOpeningBracket,
          closing_bracket: CssKeyframesExpectedClosingBracket) do
          many { comment || css_selector(only_definitions: true) }
        end

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
