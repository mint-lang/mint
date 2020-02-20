module Mint
  class Parser
    def unary_minus : Ast::UnaryMinus | Nil
      start do |start_position|
        skip unless char! '-'

        expression = self.expression

        skip unless expression

        Ast::UnaryMinus.new(
          expression: expression.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
