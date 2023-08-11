module Mint
  class Parser
    def highlight_directive : Ast::Directives::Highlight?
      start do |start_position|
        next unless keyword "@highlight"

        content =
          code_block2(
            ->{ error :highlight_directive_expected_opening_bracket do
              expected "the opening bracket of a highlight directive", word
              snippet self
            end },
            ->{ error :highlight_directive_expected_closing_bracket do
              expected "the closing bracket of a highlight directive", word
              snippet self
            end },
            ->{ error :highlight_directive_expected_body do
              expected "body of a format directive", word
              snippet self
            end })

        self << Ast::Directives::Highlight.new(
          from: start_position,
          content: content,
          to: position,
          input: data)
      end
    end
  end
end
