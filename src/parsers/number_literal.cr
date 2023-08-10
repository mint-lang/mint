module Mint
  class Parser
    def number_literal : Ast::NumberLiteral?
      start do |start_position|
        negation =
          char! '-'

        value =
          gather { chars &.ascii_number? }.to_s

        next if value.empty?

        float = false

        if char! '.'
          next error :number_literal_expected_decimal do
            expected "the decimals for a number literal", word
            snippet self
          end unless char.ascii_number?

          float = true

          value += '.'
          value += gather { chars(&.ascii_number?) }.to_s
        end

        value = "-#{value}" if negation

        self << Ast::NumberLiteral.new(
          from: start_position,
          value: value,
          float: float,
          to: position,
          input: data)
      end
    end
  end
end
