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

    def html_body(expected_closing_bracket : Proc(Nil),
                  expected_closing_tag : Proc(Nil),
                  tag : Ast::Variable | Ast::TypeId,
                  with_dashes : Bool)
      whitespace
      attributes = many { html_attribute(with_dashes) }
      whitespace

      self_closing = char! '/'
      expected_closing_bracket.call unless char! '>'

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

        expected_closing_tag.call unless keyword "</#{closing_tag}>"

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
