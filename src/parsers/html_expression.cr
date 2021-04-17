module Mint
  class Parser
    syntax_error HtmlExpressionExpectedClosingTag

    def html_expression : Ast::HtmlExpression?
      start do |start_position|
        skip unless keyword "<{"

        whitespace
        expressions = many { expression }.compact
        whitespace

        keyword! "}>", HtmlExpressionExpectedClosingTag

        self << Ast::HtmlExpression.new(
          expressions: expressions,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
