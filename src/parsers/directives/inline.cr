module Mint
  class Parser
    def inline_directive : Ast::Directives::Inline?
      start do |start_position|
        next unless keyword "@inline"

        next error :inline_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of an inline directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :inline_directive_expected_path do
          expected "the closing parenthesis of an inline directive", word
          snippet self
        end unless path = gather { chars_until ')' }

        whitespace
        next error :inline_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of an inline directive", word
          snippet self
        end unless char! ')'

        self << Ast::Directives::Inline.new(
          from: start_position,
          to: position,
          input: data,
          path: path)
      end
    end
  end
end
