class Parser
  syntax_error NumberLiteralExpectedDecimal

  def number_literal : Ast::NumberLiteral | Nil
    start do |start_position|
      negation = char! '-'

      value = gather { chars("0-9") }.to_s

      skip if value.empty?

      float = false

      if char! '.'
        raise NumberLiteralExpectedDecimal unless char.in_set? "0-9"
        value += '.'
        float = true
        value += gather { chars("0-9") }.to_s
      end

      value = "-#{value}" if negation

      Ast::NumberLiteral.new(
        from: start_position,
        value: value.to_f64,
        float: float,
        to: position,
        input: data)
    end
  end
end
