module Mint
  class Parser
    def highlight_directive : Ast::Directives::Highlight?
      parse do |start_position|
        next unless keyword! "@highlight"
        whitespace

        content =
          block(
            ->{ error :highlight_directive_expected_opening_bracket do
              expected "the opening bracket of a highlight directive", word
              snippet self
            end },
            ->{ error :highlight_directive_expected_closing_bracket do
              expected "the closing bracket of a highlight directive", word
              snippet self
            end },
            ->{ error :highlight_directive_expected_body do
              expected "the body of a highlight directive", word
              snippet self
            end })

        next unless content

        Ast::Directives::Highlight.new(
          from: start_position,
          content: content,
          to: position,
          file: file)
      end
    end
  end
end
