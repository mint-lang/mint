module Mint
  class Parser
    syntax_error HtmlAttributeExpectedOpeningBracket
    syntax_error HtmlAttributeExpectedClosingBracket
    syntax_error HtmlAttributeExpectedExpression
    syntax_error HtmlAttributeExpectedEqualSign

    def html_attribute(with_dashes : Bool = true) : Ast::HtmlAttribute | Nil
      start do |start_position|
        skip unless name = with_dashes ? variable_with_dashes : variable

        char '=', HtmlAttributeExpectedEqualSign

        if char == '"' && (value = string_literal)
          value
        else
          char '{', HtmlAttributeExpectedOpeningBracket

          whitespace
          value = expression! HtmlAttributeExpectedExpression
          whitespace

          char '}', HtmlAttributeExpectedClosingBracket
        end

        Ast::HtmlAttribute.new(
          from: start_position,
          value: value,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
