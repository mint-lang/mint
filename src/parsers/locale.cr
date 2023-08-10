module Mint
  class Parser
    def locale : Ast::Locale?
      start do |start_position|
        comment = self.comment

        next unless keyword "locale"
        whitespace

        language = gather do
          next unless char.ascii_lowercase?
          chars { |char| char.ascii_letter? || char.ascii_number? }
        end

        next error :locale_expected_language do
          expected "the language code of the locale", word
          snippet self
        end unless language
        whitespace

        fields =
          block2(
            ->{
              error :locale_expected_opening_bracket do
                expected "the opening bracket of a locale", word
                snippet self
              end
            },
            ->{
              error :locale_expected_closing_bracket do
                expected "the opening bracket of a locale", word
                snippet self
              end
            }
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
