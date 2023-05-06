module Mint
  class Parser
    syntax_error HtmlAttributeExpectedOpeningBracket
    syntax_error HtmlAttributeExpectedClosingBracket
    syntax_error HtmlAttributeExpectedExpression
    syntax_error HtmlAttributeExpectedEqualSign

    def html_attribute(with_dashes : Bool = true, fixed_name : String? = nil) : Ast::HtmlAttribute?
      start do |start_position|
        name = with_dashes ? variable_attribute_name : variable(track: false)

        next unless name
        next if fixed_name && name.value != fixed_name

        char '=', HtmlAttributeExpectedEqualSign

        case
        when keyword_ahead?("<{") && (value = html_expression)
          value
        when char == '"' && (value = string_literal)
          value
        when char == '[' && (value = array)
          value
        else
          value = code_block(
            opening_bracket: HtmlAttributeExpectedOpeningBracket,
            closing_bracket: HtmlAttributeExpectedClosingBracket,
            statement_error: HtmlAttributeExpectedExpression)
        end

        self << Ast::HtmlAttribute.new(
          value: value.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
