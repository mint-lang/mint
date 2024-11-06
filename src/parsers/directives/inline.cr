module Mint
  class Parser
    def inline_directive : Ast::Directives::Inline?
      parse do |start_position|
        next unless keyword! "@inline"

        next error :inline_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of an inline directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :inline_directive_expected_path do
          expected "the path (to the file to be inlined) of an inline directive", word
          snippet self
        end unless path = gather { chars { char != ')' } }.presence.try(&.strip)
        whitespace

        next error :inline_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of an inline directive", word
          snippet self
        end unless char! ')'

        Ast::Directives::Inline.new(
          from: start_position,
          to: position,
          file: file,
          path: path)
      end
    end
  end
end
