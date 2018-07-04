module Mint
  class Parser
    syntax_error StyleExpectedOpeningBracket
    syntax_error StyleExpectedClosingBracket
    syntax_error StyleExpectedName

    def style : Ast::Style | Nil
      start do |start_position|
        skip unless keyword "style"

        whitespace

        name = variable_with_dashes! StyleExpectedName

        body = block(
          opening_bracket: StyleExpectedOpeningBracket,
          closing_bracket: StyleExpectedClosingBracket
        ) do
          many { css_definition || css_selector || css_media || comment }.compact
        end

        definitions = [] of Ast::CssDefinition
        selectors = [] of Ast::CssSelector
        comments = [] of Ast::Comment
        medias = [] of Ast::CssMedia

        body.each do |item|
          case item
          when Ast::CssDefinition
            definitions << item
          when Ast::CssSelector
            selectors << item
          when Ast::CssMedia
            medias << item
          when Ast::Comment
            comments << item
          end
        end

        Ast::Style.new(
          definitions: definitions,
          selectors: selectors,
          from: start_position,
          comments: comments,
          medias: medias,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
