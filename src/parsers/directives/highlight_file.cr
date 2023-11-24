module Mint
  class Parser
    def highlight_file_directive : Ast::Directives::HighlightFile?
      parse do |start_position|
        next unless keyword! "@highlight-file"
        whitespace

        next error :highlight_file_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of an highlight file directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :highlight_file_directive_expected_path do
          expected "the path (to the file) of an highlight file directive", word
          snippet self
        end unless path = gather { chars { char != ')' } }.presence.try(&.strip)
        whitespace

        next error :highlight_file_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of an highlight file directive", word
          snippet self
        end unless char! ')'

        Ast::Directives::HighlightFile.new(
          from: start_position,
          to: position,
          file: file,
          path: path)
      end
    end
  end
end
