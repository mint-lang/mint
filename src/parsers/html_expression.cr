module Mint
  class Parser
    syntax_error HtmlExpressionExpectedExpression
    syntax_error HtmlExpressionExpectedClosingTag

    def html_expression : Ast::HtmlExpression?
      start do |start_position|
        skip unless keyword "<{"

        whitespace
        expression = expression! HtmlExpressionExpectedExpression
        whitespace

        keyword! "}>", HtmlExpressionExpectedClosingTag

        Ast::HtmlExpression.new(
          expression: expression.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
