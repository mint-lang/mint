module Mint
  class Parser
    syntax_error CssKeyframesExpectedOpeningBracket
    syntax_error CssKeyframesExpectedClosingBracket
    syntax_error CssKeyframesExpectedName

    def css_keyframes : Ast::CssKeyframes | Nil
      start do |start_position|
        skip unless keyword "@keyframes"

        whitespace

        name = gather { chars "^{" }.to_s.strip

        raise CssKeyframesExpectedName if name.empty?

        selectors = block(
          opening_bracket: CssKeyframesExpectedOpeningBracket,
          closing_bracket: CssKeyframesExpectedClosingBracket) do
          many { comment || css_selector(true) }.compact
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
