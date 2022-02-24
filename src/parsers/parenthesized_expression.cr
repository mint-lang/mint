module Mint
  class Parser
    syntax_error ParenthesizedExpressionExpectedClosingParentheses
    syntax_error ParenthesizedExpressionExpectedExpression

    def parenthesized_expression : Ast::ParenthesizedExpression?
      parenthesized_expression(error: true)
    end

    def parenthesized_expression_no_error : Ast::ParenthesizedExpression?
      parenthesized_expression(error: false)
    end

    private def parenthesized_expression(error : Bool) : Ast::ParenthesizedExpression?
      start do |start_position|
        next unless char! '('

        whitespace
        expression = self.expression
        unless expression
          if error
            raise ParenthesizedExpressionExpectedExpression
          else
            next
          end
        end

        whitespace

        unless char! ')'
          if error
            raise ParenthesizedExpressionExpectedClosingParentheses
          else
            next
          end
        end

        self << Ast::ParenthesizedExpression.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
