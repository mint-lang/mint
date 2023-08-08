module Mint
  class Parser
    def html_body(expected_closing_bracket : Proc(Nil),
                  expected_closing_tag : Proc(Nil),
                  tag : Ast::Variable | Ast::Id,
                  with_dashes : Bool)
      parse(track: false) do
        attributes = many { html_attribute(with_dashes) }
        whitespace

        self_closing = char! '/'
        next expected_closing_bracket.call unless char! '>'

        comments = [] of Ast::Comment
        children = [] of Ast::Node

        unless self_closing
          items = many { expression || comment }
          whitespace

          closing_tag =
            case tag
            when Ast::Variable, Ast::Id
              tag.value
            else
              tag
            end

          closing_tag_position =
            position + 2

          expected_closing_tag.call unless word! "</#{closing_tag}>"

          items.each do |item|
            case item
            when Ast::Comment
              comments << item
            when Ast::Node
              children << item
            end
          end
        end

        {attributes, children, comments, closing_tag_position}
      end
    end
  end
end
