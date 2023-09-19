module Mint
  class Parser
    def html_expression : Ast::HtmlExpression?
      parse do |start_position|
        next unless word! "<{"

        whitespace
        expressions = many { expression }
        whitespace

        next error :html_expression_expected_closing_tag do
          expected "the closing tag of an HTML expression", word
          snippet self
        end unless word! "}>"

        Ast::HtmlExpression.new(
          expressions: expressions,
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
