module Mint
  class Parser
    def decode : Ast::Decode?
      parse do |start_position|
        next unless keyword! "decode"
        whitespace

        unless keyword! "as"
          whitespace
          next error :decode_expected_subject do
            expected "the subject of a decode expression", word
            snippet self
          end unless expression = self.expression

          whitespace
          next error :decode_expected_as do
            expected %(the "as" keyword of a decode expression), word
            snippet self
          end unless keyword! "as"
        end

        whitespace
        next error :decode_expected_type do
          expected "the type of a decode expression", word
          snippet self
        end unless type = self.type

        Ast::Decode.new(
          expression: expression,
          from: start_position,
          to: position,
          type: type,
          file: file)
      end
    end
  end
end
