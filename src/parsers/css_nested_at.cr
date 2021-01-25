module Mint
  class Parser
    syntax_error CssNestedAtExpectedOpeningBracket
    syntax_error CssNestedAtExpectedClosingBracket
    syntax_error CssNestedAtExpectedCondition

    syntax_error CssNestedAtExpectedSpaceAfterKeyword

    def css_nested_at : Ast::CssNestedAt?
      start do |start_position|
        skip unless char! '@'

        name = gather { keyword("media") || keyword("supports") }

        skip unless name

        whitespace! CssNestedAtExpectedSpaceAfterKeyword

        content = gather { chars "^{" }.to_s.strip

        raise CssNestedAtExpectedCondition if content.empty?

        body = block(
          opening_bracket: CssNestedAtExpectedOpeningBracket,
          closing_bracket: CssNestedAtExpectedClosingBracket) do
          css_body
        end

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
