module Mint
  class Parser
    def html_content
      html_element ||
        html_component ||
        html_expression ||
        html_fragment ||
        string_literal ||
        array ||
        if_expression ||
        for_expression ||
        with_expression ||
        try_expression ||
        case_expression ||
        comment
    end

    def html_body(expected_closing_bracket : SyntaxError.class,
                  expected_closing_tag : SyntaxError.class,
                  tag : Ast::Variable | String,
                  with_dashes : Bool)
      whitespace
      attributes = many { html_attribute(with_dashes) }.compact
      whitespace

      self_closing = char! '/'
      char '>', expected_closing_bracket

      children = [] of Ast::HtmlContent
      comments = [] of Ast::Comment

      unless self_closing
        items = many do
          html_content.as(Ast::HtmlContent | Ast::Comment | Nil)
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

        items.each do |item|
          case item
          when Ast::Comment
            comments << item
          when Ast::HtmlContent
            children << item
          end
        end
      end

      {attributes || [] of Ast::HtmlAttribute,
       children,
       comments}
    end
  end
end
