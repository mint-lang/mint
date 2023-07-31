module Mint
  class Parser
    def html_content
      here_doc ||
        svg_directive ||
        html_element ||
        html_component ||
        html_expression ||
        html_fragment ||
        string_literal ||
        array ||
        if_expression ||
        for_expression ||
        case_expression ||
        comment
    end

    def html_body(expected_closing_bracket : SyntaxError.class,
                  expected_closing_tag : SyntaxError.class,
                  tag : Ast::Variable | Ast::TypeId,
                  with_dashes : Bool)
      whitespace
      attributes = many { html_attribute(with_dashes) }
      whitespace

      self_closing = char! '/'
      char '>', expected_closing_bracket

      children = [] of Ast::Node
      comments = [] of Ast::Comment

      unless self_closing
        items = many do
          html_content.as(Ast::Node | Ast::Comment?)
        end

        whitespace

        closing_tag =
          case tag
          when Ast::Variable, Ast::TypeId
            tag.value
          else
            tag
          end

        closing_tag_position =
          position + 2

        raise expected_closing_tag, position, {
          "opening_tag" => tag,
        } unless keyword "</#{closing_tag}>"

        items.each do |item|
          case item
          when Ast::Comment
            comments << item
          when Ast::Node
            children << item
          end
        end
      end

      {attributes,
       children,
       comments,
       closing_tag_position}
    end
  end
end
