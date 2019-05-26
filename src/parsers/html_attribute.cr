module Mint
  class Parser
    syntax_error HtmlAttributeExpectedOpeningBracket
    syntax_error HtmlAttributeExpectedClosingBracket
    syntax_error HtmlAttributeExpectedExpression
    syntax_error HtmlAttributeExpectedEqualSign

    def html_attribute(with_dashes : Bool = true, fixed_name : String | Nil = nil) : Ast::HtmlAttribute | Nil
      start do |start_position|
        name = with_dashes ? variable_attribute_name : variable

        skip unless name
        skip if fixed_name && name.value != fixed_name

        char '=', HtmlAttributeExpectedEqualSign

        if char == '"' && (value = string_literal)
          value
        elsif char == '[' && (value = array)
          value
        else
          char '{', HtmlAttributeExpectedOpeningBracket

          whitespace
          value = expression! HtmlAttributeExpectedExpression
          whitespace

          char '}', HtmlAttributeExpectedClosingBracket
        end

        Ast::HtmlAttribute.new(
          value: value.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
