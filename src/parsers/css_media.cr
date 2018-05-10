module Mint
  class Parser
    syntax_error CssMediaExpectedOpeningBracket
    syntax_error CssMediaExpectedClosingBracket
    syntax_error CssMediaExpectedName

    syntax_error CssMediaExpectedSpaceAfterKeyword

    def css_media : Ast::CssMedia | Nil
      start do |start_position|
        skip unless keyword "@media"

        whitespace! CssMediaExpectedSpaceAfterKeyword

        content = gather { chars "^{" }.to_s

        raise CssMediaExpectedName if content.strip.empty?

        definitions = block(
          opening_bracket: CssMediaExpectedOpeningBracket,
          closing_bracket: CssMediaExpectedClosingBracket) do
          many { css_definition }.compact
        end

        Ast::CssMedia.new(
          definitions: definitions,
          from: start_position,
          content: content,
          to: position,
          input: data)
      end
    end
  end
end
