module Mint
  class Parser
    def decode : Ast::Decode?
      start do |start_position|
        next unless keyword "decode"
        next unless whitespace?
        whitespace

        unless keyword "as"
          next error :decode_expected_subject do
            expected "the subject of a decode expression", word
            snippet self
          end unless expression = self.expression

          whitespace
          next error :decode_expected_as do
            expected "the as keyword of a decode expression", word
            snippet self
          end unless keyword "as"
        end

        whitespace
        next error :decode_expected_type do
          expected "the type of a decode expression", word
          snippet self
        end unless type = self.type

        self << Ast::Decode.new(
          expression: expression,
          from: start_position,
          type: type,
          to: position,
          input: data)
      end
    end
  end
end
