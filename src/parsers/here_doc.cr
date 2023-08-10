module Mint
  class Parser
    def here_doc_part(token : String)
      gather do
        while char != '\0' && !keyword_ahead?(token)
          break if char == '#' &&
                   next_char == '{' &&
                   prev_char != '\\'
          step
        end
      end
    end

    def here_doc(with_interpolation : Bool = true) : Ast::HereDoc?
      start do |start_position|
        next unless keyword "<<"
        next unless char!('~') || char!('#') || char!('-')

        modifier =
          prev_char

        head =
          gather { chars &.ascii_uppercase? }

        tail =
          gather { chars { |char| char.ascii_uppercase? || char.ascii_number? || char == '_' } }

        next error :here_doc_expected_start do
          expected "the start tag of a here document", word
          snippet self
        end unless head || tail

        token =
          "#{head}#{tail}"

        value = many(parse_whitespace: false) { here_doc_part(token) || interpolation }

        next error :here_doc_expected_end do
          expected "the end tag of a here document", word
          snippet self
        end unless keyword(token)

        Ast::HereDoc.new(
          from: start_position,
          modifier: modifier,
          value: value,
          to: position,
          input: data,
          token: token)
      end
    end
  end
end
