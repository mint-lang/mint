module Mint
  class Parser
    syntax_error HtmlExpressionExpectedExpression
    syntax_error HtmlExpressionExpectedClosingTag

    def html_expression : Ast::HtmlExpression | Nil
      start do |start_position|
        skip unless keyword "<{"

        whitespace
        expression = expression! HtmlExpressionExpectedExpression
        whitespace

        keyword! "}>", HtmlExpressionExpectedClosingTag

        Ast::HtmlExpression.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
