module Mint
  class Parser
    def number_literal : Ast::NumberLiteral?
      parse do |start_position|
        negation =
          char! '-'

        next unless value = gather { chars &.ascii_number? }

        float = false

        if char! '.'
          next error :number_literal_expected_decimal do
            expected "the decimals for a number literal", word
            snippet self
          end unless char.ascii_number?

          value += '.' + gather { chars(&.ascii_number?) }.to_s
          float = true
        end

        value = "-#{value}" if negation

        Ast::NumberLiteral.new(
          from: start_position,
          value: value,
          float: float,
          to: position,
          file: file)
      end
    end
  end
end
