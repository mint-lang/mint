module Mint
  class Parser
    syntax_error NumberLiteralExpectedDecimal

    def number_literal : Ast::NumberLiteral?
      start do |start_position|
        negation = char! '-'

        value = gather { chars &.ascii_number? }.to_s

        next if value.empty?

        float = false

        if char! '.'
          raise NumberLiteralExpectedDecimal unless char.ascii_number?
          value += '.'
          float = true
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
