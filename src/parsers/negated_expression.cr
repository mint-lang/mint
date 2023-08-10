module Mint
  class Parser
    def negated_expression : Ast::NegatedExpression?
      start do |start_position|
        negations = gather { chars '!' }
        next unless negations

        negations =
          negations.size % 2 == 0 ? "!!" : "!"

        next error :negated_expression_expected_expression do
          expected "the expression of a negated expression", word
          snippet self
        end unless expression = self.expression

        self << Ast::NegatedExpression.new(
          expression: expression,
          negations: negations,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
