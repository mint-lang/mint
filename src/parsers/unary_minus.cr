module Mint
  class Parser
    def unary_minus : Ast::UnaryMinus?
      start do |start_position|
        skip unless char! '-'

        expression = self.expression

        skip unless expression

        Ast::UnaryMinus.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
