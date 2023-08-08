module Mint
  class Parser
    def parenthesized_expression : Ast::ParenthesizedExpression?
      parse do |start_position|
        next unless char! '('
        whitespace

        next unless expression = self.expression
        whitespace

        next unless char! ')'

        Ast::ParenthesizedExpression.new(
          expression: expression,
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
