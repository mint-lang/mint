module Mint
  class Parser
    syntax_error HtmlExpressionExpectedClosingTag

    def html_expression : Ast::HtmlExpression?
      start do |start_position|
        next unless keyword "<{"

        whitespace
        expressions = many { expression }
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
