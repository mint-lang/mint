module Mint
  class Parser
    syntax_error StylesExpectedOpeningBracket
    syntax_error StylesExpectedClosingBracket
    syntax_error StylesExpectedName

    def styles : Ast::Styles?
      start do |start_position|
        comment = self.comment
        whitespace

        next unless keyword "styles"
        whitespace

        name = type_id! StylesExpectedName

        items = block(
          opening_bracket: StylesExpectedOpeningBracket,
          closing_bracket: StylesExpectedClosingBracket) do
          many { style || self.comment }.compact
        end.compact

        comments = [] of Ast::Comment
        styles = [] of Ast::Style

        items.each do |item|
          case item
          when Ast::Style
            styles << item
          when Ast::Comment
            comments << item
          else
            # ignore
          end
        end

        Ast::Styles.new(
          styles: styles,
          from: start_position,
          comments: comments,
          comment: comment,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
