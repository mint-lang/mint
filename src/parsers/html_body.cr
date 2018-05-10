module Mint
  class Parser
    def html_body(expected_closing_bracket : SyntaxError.class,
                  expected_closing_tag : SyntaxError.class,
                  tag : Ast::Variable | String,
                  with_dashes : Bool)
      whitespace
      attributes = many { html_attribute(with_dashes) }.compact
      whitespace

      self_closing = char! '/'
      char '>', expected_closing_bracket

      unless self_closing
        children = many do
          html_element.as(Ast::HtmlElement | Nil) ||
            html_component.as(Ast::HtmlComponent | Nil) ||
            html_expression.as(Ast::HtmlExpression | Nil)
        end.compact

        whitespace

        closing_tag =
          case tag
          when Ast::Variable
            tag.value
          else
            tag
          end

        keyword! "</#{closing_tag}>", expected_closing_tag
      end

      {attributes || [] of Ast::HtmlAttribute,
       children || [] of Ast::HtmlContent}
    end
  end
end
