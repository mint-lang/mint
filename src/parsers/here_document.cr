module Mint
  class Parser
    def here_document : Ast::HereDocument?
      parse do |start_position|
        next unless word! "<<"
        next unless char!('~') || char!('#') || char!('-')

        modifier =
          previous_char

        token =
          identifier_constant

        if char!('(')
          whitespace
          highlight = keyword!("highlight")

          whitespace
          next error :here_doc_expected_closing_parenthesis do
            expected "the closing parenthesis of here document flags", word
            snippet self
          end unless char!(')')
        end

        next error :here_document_expected_start do
          expected "the start tag of a here document", word
          snippet self
        end unless token

        value = many(parse_whitespace: false) { raw(token) || interpolation }

        next error :here_doc_expected_end do
          expected "the end tag of a here document", word
          snippet self
        end unless word!(token)

        Ast::HereDocument.new(
          from: start_position,
          highlight: highlight,
          modifier: modifier,
          token: token,
          value: value,
          to: position,
          file: file)
      end
    end
  end
end
