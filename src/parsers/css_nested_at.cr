module Mint
  class Parser
    def css_nested_at : Ast::CssNestedAt?
      start do |start_position|
        next unless char! '@'

        name = gather { keyword("media") || keyword("supports") }

        next unless name
        next unless whitespace?

        content =
          gather { chars_until '{' }.presence.try(&.strip)

        next error :css_nested_at_expected_condition do
          expected "the condition of a CSS at rule", word
          snippet self
        end unless content

        body = block2(
          ->{ error :css_nested_at_expected_opening_bracket do
            expected "the opening bracket of a CSS at rule", word
            snippet self
          end },
          ->{ error :css_nested_at_expected_closing_bracket do
            expected "the closing bracket of a CSS at rule", word
            snippet self
          end }) { css_body }

        next error :css_nested_at_expected_body do
          expected "the body of a CSS at rule", word
          snippet self
        end if body.empty?

        self << Ast::CssNestedAt.new(
          from: start_position,
          content: content,
          to: position,
          input: data,
          name: name,
          body: body)
      end
    end
  end
end
