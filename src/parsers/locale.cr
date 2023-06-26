module Mint
  class Parser
    syntax_error LocaleExpectedClosingBracket
    syntax_error LocaleExpectedOpeningBracket
    syntax_error LocaleExpectedLanguage

    def locale : Ast::Locale?
      start do |start_position|
        comment = self.comment

        next unless keyword "locale"
        whitespace

        language = gather do
          next unless char.ascii_lowercase?
          chars { |char| char.ascii_letter? || char.ascii_number? }
        end

        raise LocaleExpectedLanguage unless language
        whitespace

        fields = block(
          opening_bracket: LocaleExpectedOpeningBracket,
          closing_bracket: LocaleExpectedClosingBracket
        ) do
          list(terminator: '}', separator: ',') { record_field }
        end

        self << Ast::Locale.new(
          from: start_position,
          language: language,
          comment: comment,
          fields: fields,
          to: position,
          input: data)
      end
    end
  end
end
