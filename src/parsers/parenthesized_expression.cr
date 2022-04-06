module Mint
  class Parser
    def parenthesized_expression : Ast::ParenthesizedExpression?
      start do |start_position|
        next unless char! '('

        whitespace
        expression = self.expression
        next unless expression

        whitespace

        next unless char! ')'

        self << Ast::ParenthesizedExpression.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
