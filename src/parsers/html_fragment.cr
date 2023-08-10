module Mint
  class Parser
    def html_fragment : Ast::HtmlFragment?
      start do |start_position|
        next unless char! '<'

        # Test for closing tag
        whitespace
        next if char! '/'

        key = html_attribute false, "key"
        whitespace

        next error :html_fragment_expected_closing_bracket do
          expected "the closing bracket of an HTML fragment", word
          snippet self
        end unless char! '>'

        children = [] of Ast::Node
        comments = [] of Ast::Comment

        items = many do
          html_content.as(Ast::Node | Ast::Comment?)
        end

        items.each do |item|
          case item
          when Ast::Comment
            comments << item
          when Ast::Node
            children << item
          end
        end

        whitespace
        next error :html_fragment_expected_closing_tag do
          expected "the closing tag of an HTML fragment", word
          snippet self
        end unless keyword "</>"

        self << Ast::HtmlFragment.new(
          from: start_position,
          children: children,
          comments: comments,
          to: position,
          input: data,
          key: key)
      end
    end
  end
end
