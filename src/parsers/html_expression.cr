module Mint
  class Parser
    def html_expression : Ast::HtmlExpression?
      start do |start_position|
        next unless keyword "<{"

        whitespace
        expressions = many { expression }
        whitespace

        next error :html_expression_expected_closing_tag do
          expected "the closing tag of an HTML expression", word
          snippet self
        end unless keyword "}>"

        self << Ast::HtmlExpression.new(
          expressions: expressions,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
