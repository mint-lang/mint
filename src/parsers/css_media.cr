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

        body = block(
          opening_bracket: CssMediaExpectedOpeningBracket,
          closing_bracket: CssMediaExpectedClosingBracket) do
          many { css_definition || comment }.compact
        end

        definitions = [] of Ast::CssDefinition
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::CssDefinition
            definitions << item
          when Ast::Comment
            comments << item
          end
        end

        Ast::CssMedia.new(
          definitions: definitions,
          from: start_position,
          comments: comments,
          content: content,
          to: position,
          input: data)
      end
    end
  end
end
