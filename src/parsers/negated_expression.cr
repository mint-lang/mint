module Mint
  class Parser
    def negated_expression : Ast::NegatedExpression?
      parse do |start_position|
        next unless negations = gather { chars '!' }

        negations =
          negations.size % 2 == 0 ? "!!" : "!"

        next error :negated_expression_expected_expression do
          expected "the expression of a negated expression", word
          snippet self
        end unless expression = self.expression

        Ast::NegatedExpression.new(
          expression: expression,
          negations: negations,
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
